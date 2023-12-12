#define _POSIX_C_SOURCE 200809L

#include "grade_school.h"
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

static roster_t g_roster = {0};

roster_t get_roster()
{
    return g_roster;
}

void clear_roster()
{
    g_roster.count = 0;
}

int cmp_student(const student_t *a, const student_t *b)
{
    return (a->grade == b->grade)
               ? strcmp(a->name, b->name)
               : a->grade - b->grade;
}

roster_t get_grade(uint8_t desired_grade)
{
    roster_t result = {0};
    roster_t roster = get_roster();

    for (int i = 0; i < (int)roster.count; i++) {
        student_t student = roster.students[i];
        if (student.grade == desired_grade) {
            roster_add_student(&result, student.name, student.grade);
        }
    }

    return result;
}

bool roster_add_student(roster_t *roster, char *name, uint8_t grade)
{
    if (MAX_STUDENTS <= roster->count) {
        return false;
    }

    char *name_copy = strdup(name);
    if (name_copy == NULL) {
        return false;
    }

    student_t student = {
        .grade = grade,
        .name = name_copy,
    };

    insert_to_sort(roster->students, (int)roster->count, &student);
    roster->count++;

    return true;
}

void insert_to_sort(student_t *students, int len, student_t *student)
{
    int i = binary_search(students, student, 0, len - 1);
    insert(students, len, i, student);
}

void insert(student_t *students, int len, int insert_index, student_t *student)
{
    int i;
    for (i = len - 1; i >= insert_index; i--) {
        students[i + 1] = students[i];
    }
    students[insert_index] = *student;
}

// return found index or index where element could be inserted
int binary_search(student_t *students, student_t *student, int left, int right)
{
    if (right < left) {
        return right + 1;
    }

    int index = (left + right) / 2;
    student_t middle = students[index];

    int cmp = cmp_student(student, &middle);
    if (cmp == 0) {
        return index;
    }
    if (cmp > 0) {
        return binary_search(students, student, index + 1, right);
    }
    return binary_search(students, student, left, index - 1);
}

bool add_student(char *name, uint8_t grade)
{
    return roster_add_student(&g_roster, name, grade);
}
