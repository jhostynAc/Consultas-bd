Create database Nomina;

Use Nomina;

Create table Departamento(
Id_departamento Int identity (1,1) primary key,
Nombre varchar(100) not null
);

Create table Cargo (
Id_cargo int identity(1,1) primary key,
Nombre varchar(100) not null,
Salario_base decimal (10,2) not null,
Id_departamento int not null,
foreign key (Id_departamento) references Departamento (Id_departamento)
);

Create table Contrato(
Id_tipo_contrato int identity (1,1) primary key,
Descripcion varchar(50) not null,
check (Descripcion in ('Termino fijo','Termino indefinido','Prestacion de servicio'))
);

Create table Empleado(
Id_empleado int identity(1,1) primary key,
Documento numeric(20) unique not null,
Primer_nombre varchar(25) not null,
Segundo_nombre varchar (25) null,
Primer_apellido varchar(25) not null,
Segundo_apellido varchar(25) not null,
Fecha_ingreso Date not null default getdate(),
Id_cargo int not null,
Id_tipo_contrato int not null,
foreign key (Id_cargo) references Cargo (Id_cargo),
foreign key (Id_tipo_contrato) references Contrato (Id_tipo_contrato)
);

Create table Nomina(
Id_nomina int identity(1,1) primary key,
Id_empleado int not null,
Fecha_inicio date default getdate() not null,
Fecha_fin date not null,
Total_devengado decimal (10,2),
Total_deduccion decimal(10,2),
Neto_pagar decimal(10,2),
foreign key (Id_empleado) references Empleado (Id_empleado)
); 

Create table Detalle_nomina(
Id_detalle int identity(1,1) primary key,
Id_nomina int not null,
Concepto varchar(20),
Tipo varchar(20),
check(Tipo in ('Devengado','Deduccion')),
Valor Decimal(10,2) not null,
foreign key (Id_nomina) references Nomina (Id_nomina)
);

insert into Departamento values ('Recursos Humanos');
insert into Departamento values ('Sistemas');
insert into Departamento values ('Contabilidad');
insert into Departamento values ('Ventas');

insert into Cargo values ('Analista RRHH', 2500000, 1);
insert into Cargo values ('Desarrollador', 3500000, 2);
insert into Cargo values ('Contador', 3000000, 3);
insert into Cargo values ('Asesor Comercial', 2000000, 4);

insert into Contrato values ('Termino fijo');
insert into Contrato values ('Termino indefinido');  
insert into Contrato values ('Prestacion de servicio');

insert into Empleado values (1009876543,'Maria','Fernanda','Lopez','Rodriguez',getdate(),2,2);
insert into Empleado values (1011122233,'Andres','Felipe','Martinez','Torres',getdate(),3,2);
insert into Empleado values (1022233344,'Laura',null,'Sanchez','Diaz',getdate(),4,3);

insert into Nomina values (1,'2025-02-01','2025-02-15',2500000,200000,2300000);
insert into Nomina values (2,'2025-02-01','2025-02-15',3500000,300000,3200000);

insert into Detalle_nomina values (1,'Salario','Devengado',2500000);
insert into Detalle_nomina values (1,'Salud','Deduccion',100000);
insert into Detalle_nomina values (1,'Pension','Deduccion',100000);
insert into Detalle_nomina values (2,'Salario','Devengado',3500000);
insert into Detalle_nomina values (2,'Salud','Deduccion',150000);


select * from  Empleado;
select * from  Empleado where Id_tipo_contrato=2;
select * from  Cargo where Salario_base>3000000;
select e.Primer_nombre, e.Primer_apellido,c.Nombre as cargo,d.Nombre as departamrnto from Empleado e join Cargo c on e.Id_cargo = c.Id_cargo join Departamento d on c.Id_departamento= d.Id_departamento;
select e.Primer_nombre,sum(dn.Valor) as totalDevengado from Empleado e join Nomina n on e.Id_empleado=n.Id_empleado join Detalle_nomina dn on n.Id_nomina=dn.Id_nomina where dn.Tipo ='Devengado' group by e.Primer_nombre;
select e.Primer_nombre,sum(dn.Valor) as totaldeducciones from Empleado e join Nomina n on e.Id_empleado=n.Id_empleado join Detalle_nomina dn on n.Id_nomina=dn.Id_nomina where dn.Tipo ='Deduccion' group by e.Primer_nombre