#include "graphics.h"

int start() {
	ClearScreen(255, 40, 255);

	DrawCharacter(getArialCharacter, font_arial_width, font_arial_height, 'A', 10, 0, 0, 0, 0);
	DrawCharacter(getArialCharacter, font_arial_width, font_arial_height, '#', 25, 0, 0, 0, 0);

	while(1);
}