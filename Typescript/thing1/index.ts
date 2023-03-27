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

// pure functions, immutable data
let num = 123;

function toStrang(val: number): string {
    return val.toString();
}
const str = toStrang(num);

const data = Object.freeze([1,2,3,4]);

const addEmoji = (val) => toStrang(val) + ' :-)';

let blah2 = addEmoji(123);
const emojiData = data.map(addEmoji);

const appendEmoji = (fixed) => (dynamic) => fixed + dynamic;
const rain = appendEmoji('*');
const sun = appendEmoji('O');

console.log( rain(' today') );
console.log( sun(' tomorrow') );

class EmojiOne {
    icon: string;
    constructor(icon) {
        this.icon = icon
    }
}

// can be simplified 

class Emoji {

    // could use private
    constructor(private _icon: string) { } // automagically sets as a property

    get icon() {
        return this._icon
    }

    // exists a change

    static addOneTo(val) {
        return 1 + val;
    }
}

const sunObject = new Emoji("O");
// but can do this with a public property
// sunObject.icon = 'X';


// class SubclassName extends Superclass {

// mixins - decouple behavior into objects or functions that return objects

const hasName = (name) => {
    return { name }
}

const canSayHi = (name) => {
    return {
        sayHi: () => `Hello ${name}`   // backticks
    }
}

const AnotherPerson = function(name) {
    return {
        ... hasName(name),
        ... canSayHi(name)
    }
}

const person17 = AnotherPerson("Snornge")
console.log(person17.sayHi())

// kind of dozed off
// there's also `implements` vs extends


