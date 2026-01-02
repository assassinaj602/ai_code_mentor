# 🧪 Test Code Snippets for AI Code Mentor

Use these code snippets to test the AI Code Mentor app functionality.

---

## 1. Python - Syntax Error

**Code:**
```python
def calculate_area(length, width)
    area = length * width
    return area

result = calculate_area(5, 10)
print(f"The area is: {result}")
```

**Error Logs:**
```
SyntaxError: invalid syntax
  File "main.py", line 1
    def calculate_area(length, width)
                                    ^
```

**Expected Fix:** Add colon after function parameters

---

## 2. JavaScript - Array Index Out of Bounds

**Code:**
```javascript
const fruits = ['apple', 'banana', 'orange'];
let totalLength = 0;

for (let i = 0; i <= fruits.length; i++) {
    totalLength += fruits[i].length;
}

console.log('Total length:', totalLength);
```

**Error Logs:**
```
TypeError: Cannot read property 'length' of undefined
    at <anonymous>:5:27
```

**Expected Fix:** Change `i <= fruits.length` to `i < fruits.length`

---

## 3. Java - Null Pointer Exception

**Code:**
```java
public class Main {
    public static void main(String[] args) {
        String name = null;
        System.out.println("Name length: " + name.length());
    }
}
```

**Error Logs:**
```
Exception in thread "main" java.lang.NullPointerException
    at Main.main(Main.java:4)
```

**Expected Fix:** Add null check before accessing methods

---

## 4. C++ - Memory Leak

**Code:**
```cpp
#include <iostream>
using namespace std;

int main() {
    int* numbers = new int[100];
    
    for(int i = 0; i < 100; i++) {
        numbers[i] = i * 2;
    }
    
    cout << "First element: " << numbers[0] << endl;
    
    return 0;
}
```

**Error Logs:**
```
Memory leak detected: 400 bytes not freed
```

**Expected Fix:** Add `delete[] numbers;` before return

---

## 5. Python - Infinite Loop

**Code:**
```python
def countdown(n):
    while n >= 0:
        print(n)
        n += 1  # Bug: should be n -= 1

countdown(10)
```

**Error Logs:**
```
Process terminated: Maximum recursion depth exceeded
KeyboardInterrupt
```

**Expected Fix:** Change `n += 1` to `n -= 1`

---

## 6. JavaScript - Async/Await Error

**Code:**
```javascript
function fetchUserData(userId) {
    const response = await fetch(`https://api.example.com/users/${userId}`);
    const data = await response.json();
    return data;
}

fetchUserData(123)
    .then(data => console.log(data))
    .catch(err => console.error(err));
```

**Error Logs:**
```
SyntaxError: await is only valid in async functions
```

**Expected Fix:** Add `async` keyword to function declaration

---

## 7. SQL - Injection Vulnerability

**Code:**
```python
import sqlite3

def get_user(username):
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    query = f"SELECT * FROM users WHERE username = '{username}'"
    cursor.execute(query)
    
    result = cursor.fetchone()
    conn.close()
    return result

user = get_user(input("Enter username: "))
```

**Error Logs:**
```
Warning: Potential SQL injection vulnerability
```

**Expected Fix:** Use parameterized queries

---

## 8. React - Missing Dependency

**Code:**
```javascript
import React, { useEffect, useState } from 'react';

function Counter() {
    const [count, setCount] = useState(0);
    
    useEffect(() => {
        document.title = `Count: ${count}`;
    }, []); // Missing dependency
    
    return (
        <div>
            <p>Count: {count}</p>
            <button onClick={() => setCount(count + 1)}>
                Increment
            </button>
        </div>
    );
}
```

**Error Logs:**
```
Warning: React Hook useEffect has a missing dependency: 'count'
```

**Expected Fix:** Add `count` to dependency array

---

## 9. TypeScript - Type Mismatch

**Code:**
```typescript
interface User {
    id: number;
    name: string;
    email: string;
}

function printUser(user: User): void {
    console.log(`ID: ${user.id}`);
    console.log(`Name: ${user.name}`);
    console.log(`Email: ${user.email}`);
}

const user = {
    id: 1,
    name: "John Doe",
    age: 30  // Extra property
};

printUser(user);
```

**Error Logs:**
```
Type '{ id: number; name: string; age: number; }' is not assignable to type 'User'
Object literal may only specify known properties
```

**Expected Fix:** Remove `age` or update `User` interface

---

## 10. Go - Goroutine Race Condition

**Code:**
```go
package main

import (
    "fmt"
    "time"
)

var counter int

func increment() {
    counter++
}

func main() {
    for i := 0; i < 1000; i++ {
        go increment()
    }
    
    time.Sleep(time.Second)
    fmt.Println("Counter:", counter)
}
```

**Error Logs:**
```
WARNING: DATA RACE
Write at 0x... by goroutine X
Previous write at 0x... by goroutine Y
```

**Expected Fix:** Use mutex or sync.WaitGroup

---

## 11. Flutter/Dart - Null Safety Error

**Code:**
```dart
class User {
  String name;
  int age;
  
  User(this.name, this.age);
}

void main() {
  User? user;
  print('Name: ${user.name}');
  print('Age: ${user.age}');
}
```

**Error Logs:**
```
Null check operator used on a null value
```

**Expected Fix:** Add null check before accessing properties

---

## 12. CSS - Flexbox Layout Issue

**Code:**
```css
.container {
    display: flex;
    justify-content: center;
    align-items: center;
}

.item {
    width: 200px;
    height: 200px;
    background: blue;
    margin: 10px;
}
```

**Error Description:**
Items are not centering vertically as expected. Container has no height defined.

**Expected Fix:** Add height to container or use viewport units

---

## Testing Workflow

### For Each Code Snippet:

1. **Copy the Code**
   - Select and copy the buggy code

2. **Open AI Code Mentor**
   - Tap "Paste Code"

3. **Paste Code**
   - Paste into code editor

4. **Add Error Logs**
   - Copy and paste the error logs

5. **Analyze**
   - Tap "Analyze with AI"

6. **Review Results**
   - Check Root Cause tab
   - Verify Fixed Code tab
   - Compare in Diff View
   - Read explanations at different levels

7. **Check History**
   - Verify the analysis is saved
   - Can access it later from History screen

---

## Expected AI Responses

For each test case, the AI should provide:

✅ **Language Detection**: Correctly identify the programming language

✅ **Root Cause**: Clear explanation of the bug

✅ **Fixed Code**: Corrected version of the code

✅ **Beginner Explanation**: Simple, easy-to-understand explanation

✅ **Intermediate Explanation**: More technical details

✅ **Expert Explanation**: In-depth analysis with best practices

✅ **Best Practices**: Related coding standards and tips

✅ **Alternative Solutions**: Other ways to solve the problem

---

## Advanced Test Cases

### Test API Error Handling

**Test 1: Empty Input**
- Leave all fields blank
- Tap Analyze
- Should show error message

**Test 2: Very Large Code**
- Paste code with 100+ lines
- Verify performance

**Test 3: Special Characters**
- Include Unicode characters
- Test with emojis in comments

### Test UI Features

**Test 1: Theme Switching**
- Toggle between light/dark mode
- Verify all screens adapt

**Test 2: History Management**
- Add 10+ analyses
- Verify scrolling works
- Check timestamp formatting

**Test 3: Navigation**
- Test back button behavior
- Verify state preservation

---

## Performance Benchmarks

Expected response times (with good internet):

- **Simple errors**: 3-8 seconds
- **Complex analysis**: 10-20 seconds
- **With screenshot**: 15-30 seconds

If response time exceeds these ranges:
1. Check internet connection
2. Try different AI model
3. Reduce code complexity

---

**Happy Testing! 🧪**
