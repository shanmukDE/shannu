from loguru import logger

labour_with_cost = {"Mahe":200,"shsan":300,"misndf":100,"ndisojd":500}


# logger.info(labour_with_cost.keys())

# logger.info(labour_with_cost.values())

# logger.info(labour_with_cost.items())

# for name in labour_with_cost:
#     logger.info(f"{name},{labour_with_cost[name]}")

# # logger.info(f"Labour with costs: {labour_with_cost}")

# for key,value in labour_with_cost.items():
#     logger.info(f"{key},{value}value")




# ASSIGNMENT 1
labour_with_cost = {
    "Mahe": 200,
    "shsan": 300,
    "misndf": 100,
    "ndisojd": 500
}

total_working_days = 50

absent_days = {
    "Mahe": 3,
    "misndf": 7
}

total_labour_cost = 0

for labour, daily_cost in labour_with_cost.items():
    worked_days = total_working_days - absent_days.get(labour, 0)
    labour_cost = worked_days * daily_cost

    print(f"{labour} worked {worked_days} days, Cost = ${labour_cost}")

    total_labour_cost += labour_cost

print(f"\nTotal Labour Cost = ${total_labour_cost}")


