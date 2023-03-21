// import * as _ from 'lodash'

console.log("Snorgle")

async function hello() {
    return "snorgle"
}


let lucky = 23;
// lucky = '23'; // error

let unlucky: any = 23;
unlucky = '23';

// let blah: number = 'string';  // annotation

type TypeName = string;
let blargh: TypeName;

// union type

type Style = 'bold' | 'italic' | 23;
let font2: Style;

// enforce shapes with interface

interface Person {
    first: string;
    last: string;
    [key: string]: any;  // allow things like "cute" below
}

const person: Person = {
    first: 'Bob',
    last: 'Cat'
}

const person2: Person = {
    first: "Hoover",
    last: "Cat",
    cute: true
}

function tvPow(x: number, y: number): string {
    return Math.pow(x, y).toString();
}

// can also use void return type annotation

// tvPow("hello", "Sailor") // type error

let blah = tvPow(5, 10)
console.log(blah)

const arr: number[] = []   // number[] -is-like-> [Number]
arr.push(1);
// arr.push("23"); // error
// arr.push(false); // error

const arrMeHearties: Person[] = []

// Tuples - fixed length array where each element has its own type
type SomeTupile = [number, string, boolean]
const tupiles: SomeTupile = [1, "23", false];


// ? for optionals

// Generics

class Observable<T> {
   constructor(public value: T) { }
}

let x: Observable<number>;
let y: Observable<Person>;
let z = new Observable(23); // implicit

