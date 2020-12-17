const fs = require('fs');

let space = new Set();
let space4 = new Set();

try {
    // read contents of the file
    const data = fs.readFileSync('input.txt', 'UTF-8');

    // split the contents by new line
    const lines = data.split(/\r?\n/);

    // print all lines
	let y = 0;
    lines.forEach((line) => {
		let x = 0;
        for (let c of line) {
			if (c === '#') {
				space.add(JSON.stringify([x, y, 0]));
				space4.add(JSON.stringify([x, y, 0, 0]));
			}
			x++;
		}
		y++;
    });
} catch (err) {
    console.error(err);
}

function Neighbors(x, y, z) {
	let neighbors = new Set();
	for (let dx = -1; dx <= 1; dx++) {
		for (let dy = -1; dy <= 1; dy++) {
			for (let dz = -1; dz <= 1; dz++) {
				if (dx === 0 && dy === 0 && dz === 0) {
					continue;
				}
				neighbors.add(JSON.stringify([(x + dx), (y + dy), (z + dz)]));
			}
		}
	}
	return neighbors;
}

function Neighbors4(x, y, z, w) {
	let neighbors = new Set();
	for (let dx = -1; dx <= 1; dx++) {
		for (let dy = -1; dy <= 1; dy++) {
			for (let dz = -1; dz <= 1; dz++) {
				for (let dw = -1; dw <= 1; dw++) {
					if (dx === 0 && dy === 0 && dz === 0 && dw == 0) {
						continue;
					}
					neighbors.add(JSON.stringify([(x + dx), (y + dy), (z + dz), (w + dw)]));
				}
			}
		}
	}
	return neighbors;
}

for (let step = 0; step < 6; step++) {
	let next_space = new Set();
	let to_check = new Set();
	for (let _p of Array.from(space)) {
		let [x, y, z] = JSON.parse(_p);
		to_check = new Set([...to_check, ...Neighbors(x, y, z), _p]);
	}
	
	for (let _p of Array.from(to_check)) {
		let [x, y, z] = JSON.parse(_p);
		let neighbor_count = 0;
		
		// count number of neighbors for point
		Array.from(Neighbors(x, y, z)).forEach(
			p => { if (space.has(p)) { neighbor_count++; } }
		);
		
		// currently active
		if (space.has(_p) && ((neighbor_count === 2) || (neighbor_count === 3))) {
			// remain active
			next_space.add(_p);
		}
		else if (!space.has(_p) && (neighbor_count === 3)) {
			// inactive, become active
			next_space.add(_p);
		}
	}
	
	space = next_space;
}
console.log(space.size);

for (let step = 0; step < 6; step++) {
	let next_space = new Set();
	let to_check = new Set();
	for (let _p of Array.from(space4)) {
		let [x, y, z, w] = JSON.parse(_p);
		to_check = new Set([...to_check, ...Neighbors4(x, y, z, w), _p]);
	}
	
	for (let _p of Array.from(to_check)) {
		let [x, y, z, w] = JSON.parse(_p);
		let neighbor_count = 0;
		
		// count number of neighbors for point
		Array.from(Neighbors4(x, y, z, w)).forEach(
			p => { if (space4.has(p)) { neighbor_count++; } }
		);
		
		// currently active
		if (space4.has(_p) && ((neighbor_count === 2) || (neighbor_count === 3))) {
			// remain active
			next_space.add(_p);
		}
		else if (!space4.has(_p) && (neighbor_count === 3)) {
			// inactive, become active
			next_space.add(_p);
		}
	}
	
	space4 = next_space;
}

console.log(space4.size);
