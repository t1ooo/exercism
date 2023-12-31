#ifndef GRADE_SCHOOL_H
#define GRADE_SCHOOL_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#define MAX_NAME_LENGTH 20
#define MAX_STUDENTS 20

typedef struct
{
   uint8_t grade;
   char *name;
} student_t;

typedef struct
{
   size_t count;
   student_t students[MAX_STUDENTS];
} roster_t;

roster_t get_roster();

void clear_roster();

roster_t get_grade(uint8_t desired_grade);

bool roster_add_student(roster_t *roster, char *name, uint8_t grade);

bool add_student(char *name, uint8_t grade);

int cmp_student(const student_t *a, const student_t *b);

void insert_to_sort(student_t *students, int len, student_t *student);

void insert(student_t *students, int len, int index, student_t *student);

int binary_search(student_t *students, student_t *student, int left, int right);

#endif
