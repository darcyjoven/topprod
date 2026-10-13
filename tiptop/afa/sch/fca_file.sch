/*
================================================================================
檔案代號:fca_file
檔案名稱:盘点资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fca_file
(
fca01       varchar2(20) NOT NULL,   /*盘点编号                               */
fca02       number(5) NOT NULL,      /*盘点序号                               */
fca03       varchar2(10),            /*财产编号                               */
fca031      varchar2(4),             /*财产附号                               */
fca04       varchar2(10),            /*序号                                   */
fca05       varchar2(10),            /*保管部门                               */
fca06       varchar2(10),            /*保管人员                               */
fca07       varchar2(10),            /*存放位置                               */
fca08       varchar2(4),             /*单位                                   */
fca09       number(5),               /*盘点数量                               */
fca10       varchar2(10),            /*实际保管部门                           */
fca11       varchar2(10),            /*实际保管人员                           */
fca12       varchar2(10),            /*实际存放位置                           */
fca13       date,                    /*盘点日期                               */
fca14       varchar2(10),            /*盘点人员                               */
fca15       varchar2(1),             /*过帐码                                 */
fca16       varchar2(10),            /*生成人员                               */
fca17       date,                    /*生成日期                               */
fca18       date,                    /*修正日期                               */
fca19       date,                    /*打印日期                               */
fca20       number(5),               /*打印次数                               */
fcalegal    varchar2(10) NOT NULL,   /*所属法人                               */
fca21       varchar2(10)             /*族群编号                               */
);

create unique index fca_02 on fca_file (fca01,fca03,fca031);
alter table fca_file add  constraint fca_pk primary key  (fca01,fca02) enable validate;
grant select on fca_file to tiptopgp;
grant update on fca_file to tiptopgp;
grant delete on fca_file to tiptopgp;
grant insert on fca_file to tiptopgp;
grant index on fca_file to public;
grant select on fca_file to ods;
