clc; clearvars; close all
syms k d m L g Ixx Iyy Izz s

A = [
    0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, g, 0, 0, 0;
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0,-g, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
];

B = [
             0,        0,       0,       0,   0,   0;
             0,        0,       0,       0, 1/m,   0;
             0,        0,       0,       0,   0,   0;
             0,        0,       0,       0,   0, 1/m;
             0,        0,       0,       0,   0,   0;
           k/m,      k/m,     k/m,     k/m,   0,   0;
             0,        0,       0,       0,   0,   0;
             0, -L*k/Ixx,       0, L*k/Ixx,   0,   0;
             0,        0,       0,       0,   0,   0;
      -L*k/Iyy,        0, L*k/Iyy,       0,   0,   0;
             0,        0,       0,       0,   0,   0;
         d/Izz,   -d/Izz,   d/Izz,  -d/Izz,   0,   0;
];

C = [
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0;
];