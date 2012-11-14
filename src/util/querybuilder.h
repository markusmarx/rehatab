/**
 *  Copyright (C) 2012  Markus Marx
 *  Contact: markus.marx@outlook.com
 *  This file is part of the Keepgoing application.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef QUERYBUILDER_H
#define QUERYBUILDER_H

#include <QSharedDataPointer>

class querybuilderData;

/**
 * @brief The querybuilder class is a querybuilder for sqlite database.
 */
class querybuilder
{
public:
querybuilder();
querybuilder(const querybuilder &);
querybuilder &operator=(const querybuilder &);
~querybuilder();

private:
QSharedDataPointer<querybuilderData> data;
};

#endif // QUERYBUILDER_H
