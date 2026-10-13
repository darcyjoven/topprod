/*
================================================================================
檔案代號:hrdq_file
檔案名稱:排班信息资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdq_file
(
hrdq01      varchar2(10) NOT NULL,   /*单据编号                               */
hrdq02      varchar2(1) NOT NULL,    /*人员类别                               */
hrdq03      varchar2(60) NOT NULL,   /*人员编号                               */
hrdq04      varchar2(60) NOT NULL,   /*名称                                   */
hrdq05      date,                    /*日期                                   */
hrdq06      varchar2(60) NOT NULL,   /*班次编号                               */
hrdq07      varchar2(60) NOT NULL,   /*班次名称                               */
hrdq08      varchar2(1),             /*班组排班                               */
hrdq09      varchar2(20),            /*班组编号                               */
hrdq10      varchar2(60),            /*班组名称                               */
hrdq11      varchar2(20) NOT NULL,   /*公司编号                               */
hrdq12      varchar2(20) NOT NULL,   /*日期类型                               */
hrdq13      varchar2(1) NOT NULL,    /*星期                                   */
hrdqud01    varchar2(255),
hrdqud02    varchar2(40),
hrdqud03    varchar2(40),
hrdqud04    varchar2(40),
hrdqud05    varchar2(40),
hrdqud06    varchar2(40),
hrdqud07    number(15,3),
hrdqud08    number(15,3),
hrdqud09    number(15,3),
hrdqud10    number(10),
hrdqud11    number(10),
hrdqud12    number(10),
hrdqud13    date,
hrdqud14    date,
hrdqud15    date,
hrdquser    varchar2(40),
hrdqmodu    varchar2(40),
hrdqorig    varchar2(40),
hrdqdate    date,
hrdqoriu    varchar2(40),
hrdqgrup    varchar2(40)
);

alter table hrdq_file add  constraint hrdq_pk primary key  (hrdq01) enable validate;
grant select on hrdq_file to tiptopgp;
grant update on hrdq_file to tiptopgp;
grant delete on hrdq_file to tiptopgp;
grant insert on hrdq_file to tiptopgp;
grant index on hrdq_file to public;
grant select on hrdq_file to ods;
