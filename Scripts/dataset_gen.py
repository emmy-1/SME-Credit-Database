from faker import Faker
import random 

fake = Faker("ng_NG")
for i in range(10):
    first = fake.first_name()
    last = fake.last_name()
    dob = fake.date_of_birth(minimum_age=18, maximum_age=60)
    phone = "0" + str(random.randint(7000000000, 9099999999))
    email = fake.email()
    bvn = random.randint(20000000000, 29999999999)

    print(
        "INSERT INTO msmes.owner (\n"
        "    first_name,\n"
        "    last_name,\n"
        "    date_of_birth,\n"
        "    phone_no,\n"
        "    email,\n"
        "    bvn\n"
        ")\nVALUES (\n"
        f"    '{first}',\n"
        f"    '{last}',\n"
        f"    '{dob}',\n"
        f"    '{phone}',\n"
        f"    '{email}',\n"
        f"    '{bvn}'\n"
        ");\n"
    )