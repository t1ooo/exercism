#include "robot_simulator.h"
#include <stdlib.h>
#include <string.h>

robot_status_t robot_create(robot_direction_t direction, int x, int y)
{
    return (robot_status_t){direction, {x, y}};
}

static void turn_right(robot_status_t *robot)
{
    robot->direction = (robot->direction + 1 + DIRECTION_MAX) % DIRECTION_MAX;
}

static void turn_left(robot_status_t *robot)
{
    robot->direction = (robot->direction - 1 + DIRECTION_MAX) % DIRECTION_MAX;
}

static void advance(robot_status_t *robot)
{
    switch (robot->direction) {
    case DIRECTION_NORTH:
        robot->position.y++;
        break;
    case DIRECTION_EAST:
        robot->position.x++;
        break;
    case DIRECTION_SOUTH:
        robot->position.y--;
        break;
    case DIRECTION_WEST:
        robot->position.x--;
        break;
    default:
        break;
    }
}

void robot_move(robot_status_t *robot, const char *commands)
{
    for (size_t i = 0, len = strlen(commands); i < len; i++) {
        switch (commands[i]) {
        case 'R':
            turn_right(robot);
            break;
        case 'L':
            turn_left(robot);
            break;
        case 'A':
            advance(robot);
            break;
        default:
            break;
        }
    }
}
