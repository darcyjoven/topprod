/*
================================================================================
檔案代號:hrck_file
檔案名稱:人员群组维护作业单头
檔案目的:人员群组文虎作业单头
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrck_file
(
hrck01      varchar2(20) NOT NULL,   /*群组编号                               */
hrck02      varchar2(20),            /*群组名称                               */
hrck12      varchar2(255),           /*备注                                   */
hrckacti    varchar2(1),             /*资料有效否                             */
hrckud01    varchar2(255),           /*自订栏位1                              */
hrckud02    varchar2(40),            /*自订栏位2                              */
hrckud03    varchar2(40),            /*自订栏位3                              */
hrckud04    varchar2(40),            /*自订栏位4                              */
hrckud05    varchar2(40),            /*自订栏位5                              */
hrckud06    varchar2(40),            /*自订栏位6                              */
hrckud07    number(15,3),            /*自订栏位7                              */
hrckud08    number(15,3),            /*自订栏位8                              */
hrckud09    number(15,3),            /*自订栏位9                              */
hrckud10    number(10),              /*自订栏位10                             */
hrckud11    number(10),              /*自订栏位11                             */
hrckud12    number(10),              /*自订栏位12                             */
hrckud13    date,                    /*自订栏位13                             */
hrckud14    date,                    /*自订栏位14                             */
hrckud15    date,                    /*自订栏位15                             */
hrckuser    varchar2(10),            /*资料所有者                             */
hrckgrup    varchar2(10),            /*资料所有群                             */
hrckmodu    varchar2(10),            /*资料更改者                             */
hrckdate    date,                    /*最近修改日                             */
hrckorig    varchar2(10),            /*资料建立部门                           */
hrckoriu    varchar2(10)             /*资料建立者                             */
);

create unique index tpc_hrck01 on hrck_file (hrck01);
alter table hrck_file add  constraint tpc_hrck_pk primary key  (hrck01) enable validate;
grant select on hrck_file to tiptopgp;
grant update on hrck_file to tiptopgp;
grant delete on hrck_file to tiptopgp;
grant insert on hrck_file to tiptopgp;
grant index on hrck_file to public;
grant select on hrck_file to ods;
