/*
================================================================================
檔案代號:bga_file
檔案名稱:预估汇率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bga_file
(
bga01       varchar2(10) NOT NULL,   /*版本                                   */
bga02       number(5) NOT NULL,      /*年度                                   */
bga03       number(5) NOT NULL,      /*月份                                   */
bga04       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
bga05       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
bgaacti     varchar2(1),             /*资料有效码                             */
bgauser     varchar2(10),            /*资料所有者                             */
bgagrup     varchar2(10),            /*资料所有部门                           */
bgamodu     varchar2(10),            /*资料更改者                             */
bgadate     date,                    /*最近更改日                             */
bgaorig     varchar2(10),            /*资料建立部门                           */
bgaoriu     varchar2(10)             /*资料建立者                             */
);

alter table bga_file add  constraint bga_pk primary key  (bga01,bga02,bga03,bga04) enable validate;
grant select on bga_file to tiptopgp;
grant update on bga_file to tiptopgp;
grant delete on bga_file to tiptopgp;
grant insert on bga_file to tiptopgp;
grant index on bga_file to public;
grant select on bga_file to ods;
