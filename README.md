<h1>MemoryLane</h1>
By allowing users to digitize, organize, and contextualize documents, MemoryLane aims to protect family and personal documents from the risk of being lost/stolen or damaged; the app also prevents disorganization and accessibility barriers caused by physical storage based in one or more locations. 

<h2>The Project</h2>

**Demo:** <br>
https://youtu.be/O1-0wdeZQpk <br><br>
**Screenshots:** <br>
<img src="https://github.com/user-attachments/assets/197a3ba2-0300-4583-9192-d62edaf212fa" width="150" alt="Simulator Screenshot - iPhone 15 Pro - 2024-07-21 at 20 19 47"/>
<img src="https://github.com/user-attachments/assets/5306c408-501f-4dc6-b30d-de9e4a4f1f25" width="150" alt="Simulator Screenshot - iPhone 15 Pro - 2024-07-21 at 20 23 28"/>
<img src="https://github.com/user-attachments/assets/4a535581-7db7-4216-ad7f-0cc3d53e180b" width="150" alt="Simulator Screenshot - iPhone 15 Pro - 2024-07-21 at 20 24 06"/><br>
<img src="https://github.com/user-attachments/assets/8a8c7f39-dc9c-4290-afba-ac718f72a3c1" width="150" alt="Simulator Screenshot - iPhone 15 Pro - 2024-07-21 at 20 24 26"/>
<img src="https://github.com/user-attachments/assets/1f019693-b19e-4c8b-a32b-875d66c167b2" width="150" alt="Simulator Screenshot - iPhone 15 Pro - 2024-07-21 at 20 25 12"/>
<img src="https://github.com/user-attachments/assets/c03c53e4-4423-41df-a8e9-dc21d9b8c06d" width="150" alt="Simulator Screenshot - iPhone 15 Pro - 2024-07-21 at 20 25 19"/>
<img src="https://github.com/user-attachments/assets/6fa1df3f-4e1d-40e2-ab5b-8f2a67d5dfc9" width="150" alt="Simulator Screenshot - iPhone 15 Pro - 2024-07-21 at 20 25 32"/>

**Tech Used:** 
- Swift
- Swift UI
- Supabase + Supabase Storage

<h2>Lesson's Learned</h2>
In creating this project I gained exposure to Supabase and broadly interacting with a database via Swift. I reaffirmed and built upon my previous experience with PostgreSQL by designing my desired tables and their relationships before beginning the project, and through the implementation of create, read, and delete operations. I realized early on that my tables needed to interact in more ways than I anticipated--that is an oversight that I will question in future projects that utilize PostgreSQL.<br><br>

Additionally, my project makes use of the MVVM design pattern. Though I am familiar with this architecture, I benefited greatly from practicing it through MemoryLane. In the future, I want to be more conscious of when and how a view model should be utilized and identify when one might be superfluous. I also gained a new understanding of @EnvironmentObjects and Manager classes through applying them in this project. 
<h2>Optimizations</h2>
As I gained more experience with Supabase, I consolidated many of the database queries into a single or handful of instances and stored the data locally to view models--this greatly reduced the loading time between views and of the document files.
<h2>Future Considerations</h2>
