/*
================================================================================
檔案代號:bwg_file
檔案名稱:销售,报废,外运折合资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bwg_file
(
bwg00       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別: L:內銷 F:外銷 S:報廢 T:外運      */
bwg01       varchar2(40) NOT NULL,   /*主件料号                               */
bwg02       date NOT NULL,           /*生效日期                               */
bwg03       number(5) NOT NULL,      /*序号                                   */
bwg04       varchar2(40),            /*料件编号                               */
bwg041      number(16,8),            /*组成用量                               */
bwg05       number(15,3),            /*折合数量                               */
                                     /*庫存單位                               */
bwg011      number(5) NOT NULL,      /*年度                                   */
bwgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bwglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bwg_file add  constraint bwg_pk primary key  (bwg00,bwg01,bwg02,bwg03,bwg011) enable validate;
grant select on bwg_file to tiptopgp;
grant update on bwg_file to tiptopgp;
grant delete on bwg_file to tiptopgp;
grant insert on bwg_file to tiptopgp;
grant index on bwg_file to public;
grant select on bwg_file to ods;
