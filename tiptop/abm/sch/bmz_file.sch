/*
================================================================================
檔案代號:bmz_file
檔案名稱:工程变异单主件档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bmz_file
(
bmz01       varchar2(20) NOT NULL,   /*ECN.单号                               */
                                     /*ECN.單號                               */
bmz02       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
bmz03       varchar2(10),            /*版本                                   */
bmz04       varchar2(10),            /*原版本                                 */
bmz05       varchar2(20) NOT NULL,   /*特性代码                               */
bmzplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bmzlegal    varchar2(10) NOT NULL,   /*所属法人                               */
bmz011      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺编号*/
bmz012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
bmz013      number(5) DEFAULT '0' NOT NULL /*工艺序*/
);

alter table bmz_file add  constraint bmz_pk primary key  (bmz01,bmz02,bmz05,bmz011,bmz012,bmz013) enable validate;
grant select on bmz_file to tiptopgp;
grant update on bmz_file to tiptopgp;
grant delete on bmz_file to tiptopgp;
grant insert on bmz_file to tiptopgp;
grant index on bmz_file to public;
grant select on bmz_file to ods;
