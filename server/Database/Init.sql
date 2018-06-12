drop database if exists dpjames;
create database dpjames;
use dpjames;

create table Person (
   id int auto_increment primary key,
   firstName varchar(30),
   lastName varchar(30) not null,
   email varchar(30) not null,
   password varchar(50),
   whenRegistered datetime not null,
   termsAccepted datetime,
   role int unsigned not null,  # 0 normal, 1 admin
   isHome int not null,
   unique key(email)
);

create table Conversation (
   id int auto_increment primary key,
   ownerId int,
   title varchar(80) not null,
   lastMessage datetime,
   constraint FKMessage_ownerId foreign key (ownerId) references Person(id)
    on delete cascade,
   unique key UK_title(title)
);

create table Message (
   id int auto_increment primary key,
   cnvId int not null,
   prsId int not null,
   whenMade datetime not null,
   content varchar(5000) not null,
   constraint FKMessage_cnvId foreign key (cnvId) references Conversation(id)
    on delete cascade,
   constraint FKMessage_prsId foreign key (prsId) references Person(id)
    on delete cascade
);
create table Chores (
   id int auto_increment primary key,
   name varchar(100),
   description varchar(5000),
   startTime datetime not null,
   duration bigint not null,
   owner varchar(100),
   isRecurring int not null,
   notify int not null
);

insert into Person (firstName, lastName, email,       password,   whenRegistered, role, isHome)
            VALUES ("Joe",     "Admin", "adm@11.com", "password", NOW(), 1, 0);
