import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker()

# 1. Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="akai_lis",
    user="postgres",
    password="YOUR_PASSWORD_HERE", # Replace with your actual password
    host="localhost",
    port="5432"
)
cur = conn.cursor()
print("Connected to akai_lis successfully!")

# Optional: Clear existing data for a fresh clean seed
cur.execute("TRUNCATE patients, users, accession_orders, specimens, lab_results, loinc_map RESTART IDENTITY CASCADE;")

# 2. Seed LOINC Lookup Data
loinc_data = [
    ('2345-7', 'Glucose [Mass/volume] in Serum or Plasma', 'mg/dL', '70-99'),
    ('4544-3', 'Hematocrit [Volume Fraction] of Blood', '%', '37.0-51.0'),
    ('718-7', 'Hemoglobin [Mass/volume] in Blood', 'g/dL', '12.0-17.5'),
    ('6690-2', 'Leukocytes [#/volume] in Blood', '10*3/uL', '4.5-11.0'),
    ('17861-6', 'Calcium [Mass/volume] in Serum or Plasma', 'mg/dL', '8.5-10.2')
]

for code, name, units, ref in loinc_data:
    cur.execute("""
        INSERT INTO loinc_map (loinc_code, test_name, units, ref_range)
        VALUES (%s, %s, %s, %s) ON CONFLICT DO NOTHING;
    """, (code, name, units, ref))

# 3. Seed Lab Users
user_ids = []
roles = ['technician', 'clinician', 'admin']
for i in range(5):
    username = f"user_{fake.user_name()}"
    display_name = fake.name()
    role = random.choice(roles)
    cur.execute("""
        INSERT INTO users (username, display_name, role)
        VALUES (%s, %s, %s) RETURNING user_id;
    """, (username, display_name, role))
    user_ids.append(cur.fetchone()[0])

# 4. Seed Patients (With Gender-Matched Names)
patient_ids = []
for _ in range(50):
    mrn = f"MRN{fake.unique.random_number(digits=8, fix_len=True)}"
    sex = random.choice(['M', 'F'])
    
    # Match first name to gender!
    if sex == 'M':
        first_name = fake.first_name_male()
    else:
        first_name = fake.first_name_female()
        
    last_name = fake.last_name()
    dob = fake.date_of_birth(minimum_age=18, maximum_age=90)
    
    cur.execute("""
        INSERT INTO patients (mrn, first_name, last_name, dob, sex)
        VALUES (%s, %s, %s, %s, %s) RETURNING patient_id;
    """, (mrn, first_name, last_name, dob, sex))
    patient_ids.append(cur.fetchone()[0])

print(f"Seeded {len(patient_ids)} patients with correct gender alignment.")

# 5. Seed Orders, Specimens & Results
statuses = ['ordered', 'collected', 'canceled']
flags = ['normal', 'normal', 'normal', 'abnormal', 'critical'] # Higher probability of normal

for p_id in patient_ids:
    # Each patient gets 1 to 3 lab orders
    for _ in range(random.randint(1, 3)):
        acc_num = f"ACC{fake.unique.random_number(digits=10, fix_len=True)}"
        provider = f"Dr. {fake.last_name()}"
        order_time = fake.date_time_between(start_date='-30d', end_date='now')
        
        cur.execute("""
            INSERT INTO accession_orders (accession_number, patient_id, ordering_provider, order_datetime, status)
            VALUES (%s, %s, %s, %s, 'collected') RETURNING order_id;
        """, (acc_num, p_id, provider, order_time))
        order_id = cur.fetchone()[0]

        # Create Specimen
        coll_time = order_time + timedelta(minutes=random.randint(15, 60))
        rec_time = coll_time + timedelta(minutes=random.randint(30, 90))
        
        cur.execute("""
            INSERT INTO specimens (order_id, specimen_type, collection_datetime, received_datetime)
            VALUES (%s, 'blood', %s, %s) RETURNING specimen_id;
        """, (order_id, coll_time, rec_time))
        specimen_id = cur.fetchone()[0]

        # Create Lab Result
        loinc = random.choice(loinc_data)
        flag = random.choice(flags)
        
        # Generate dummy result value based on test type
        if loinc[0] == '2345-7': # Glucose
            val = str(random.randint(65, 180))
        else:
            val = str(round(random.uniform(3.5, 18.0), 1))
            
        result_time = rec_time + timedelta(minutes=random.randint(45, 120))
        
        cur.execute("""
            INSERT INTO lab_results (specimen_id, test_code, test_name, result_value, units, ref_range, result_flag, result_datetime, reported_datetime)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
        """, (specimen_id, loinc[0], loinc[1], val, loinc[2], loinc[3], flag, result_time, result_time))

# Save & Commit
conn.commit()
cur.close()
conn.close()
print("Entire clinical database populated successfully!")
