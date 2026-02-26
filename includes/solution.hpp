#ifndef SOLUTION_HPP
#define SOLUTION_HPP

#include <vector>

const int kBoardSize = 3;

void InitializeBoard(std::vector<std::vector<char>>& board);

bool MakeMove(std::vector<std::vector<char>>& board,
              int row,
              int col,
              char player);

char CheckWinner(const std::vector<std::vector<char>>& board);

bool IsBoardFull(const std::vector<std::vector<char>>& board);

void SwitchPlayer(char& player);

#endif