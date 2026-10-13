/*
================================================================================
檔案代號:abl_file
檔案名稱:预付暨递延费用基本资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table abl_file
(
abl00       varchar2(1) NOT NULL,    /*性质                                   */
abl01       varchar2(10) NOT NULL,   /*费用编号                               */
abl02       date,                    /*发生日期                               */
abl03       varchar2(1),             /*分摊方式                               */
abl04       varchar2(1),             /*开始摊                                 */
abl04a      date,                    /*开始摊日期                             */
abl05       varchar2(1),             /*抛凭证                                 */
abl06       date,                    /*摊提期间                               */
abl07       date,                    /*摊提期间                               */
abl08       number(5),               /*天数                                   */
abl09       varchar2(10),            /*处理人员                               */
abl10       number(20,6),            /*费用总额                               */
abl11       number(20,6),            /*已摊金额                               */
abl12       varchar2(10),            /*部门                                   */
ablconf     varchar2(1),             /*确认码                                 */
ablacti     varchar2(1),             /*资料有效码                             */
abluser     varchar2(10),            /*资料所有者                             */
ablgrup     varchar2(10),            /*资料所有群                             */
ablmodu     varchar2(10),            /*资料更改者                             */
abldate     date,                    /*最近更改日                             */
ablorig     varchar2(10),            /*资料建立部门                           */
abloriu     varchar2(10)             /*资料建立者                             */
);

alter table abl_file add  constraint abl_pk primary key  (abl00,abl01) enable validate;
grant select on abl_file to tiptopgp;
grant update on abl_file to tiptopgp;
grant delete on abl_file to tiptopgp;
grant insert on abl_file to tiptopgp;
grant index on abl_file to public;
grant select on abl_file to ods;
