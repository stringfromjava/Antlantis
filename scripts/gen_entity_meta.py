import sys
import json

valid_chars = 'abcdefghijklmnopqrstuvwxyz' # For the ID of the entity
valid_types = ['worker', 'defender'] # TODO: Change these to be more realistic
maximum_work_hours = 1200.0

def check_valid_number(num, err_msg = '<This error message was not set.>'):
    if num.strip().isdigit():
        return float(num.strip())
    else:
        crash(err_msg)
        return 0


def crash(err_msg):
    print('ERROR!', err_msg)
    sys.exit(0)


name = input('What would you like the name of the entity to be? (This is what the user will see in-game) -> ')
health = input('How much health should this entity have? (Must be an int or float) -> ')
strength = input('How much damage should this entity do? (Anything <= 0 will make it run away when danger is near) -> ')
entity_type = input('What type should the entity be? (Check "valid_types" in this script for valid entity types) -> ')
is_hostile = input('Is this entity hostile towards other entities? (A.K.A. is it an enemy? If "y" then "worker" is ignored and the entity\'s behavior is defined by code) [y/n] -> ')
active_hours = input('What hours should the entity be active? (If it is hostile, this is the times it can attack. Separate two ints/floats by a comma. First number is the start, second is end) -> ')

health = check_valid_number(health, 'The health provided isn\'t a valid number.')
strength = check_valid_number(strength, 'The strength provided isn\'t a valid number.')

is_hostile = is_hostile.lower().strip()
if is_hostile == 'y':
    is_hostile = True
elif is_hostile == 'n':
    is_hostile = False
else:
    crash('The value provided for its hostility isn\'t valid (must be "y" or "n").')

if not is_hostile:
    entity_type = entity_type.lower().strip()
    if valid_types.index(entity_type) == -1:
        crash('The entity type provided is not valid.')
else:
    entity_type = None

active_hours = active_hours.split(',')

id = ''
for c in name:
    c = c.lower()
    if c != ' ':
        if valid_chars.find(c) != -1:
            id += c
    else:
        id += '-'

# Create the file
file = open(id + '.json', 'w')
s = check_valid_number(active_hours[0], 'One of the active hours provided is incorrect.')
e = check_valid_number(active_hours[1], 'One of the active hours provided is incorrect.')
if s < 0:
    s = 0
if e > maximum_work_hours:
    e = maximum_work_hours

data = {
    'name': name,
    'health': health,
    'strength': strength,
    'type': entity_type,
    'ishostile': is_hostile,
    'activehours': [s, e]
}
file.write(json.dumps(data, indent=2) + '\n')
file.close()

print('File was successfully created with the name "' + file.name + '"!')