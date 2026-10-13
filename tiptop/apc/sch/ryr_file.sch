/*
================================================================================
檔案代號:ryr_file
檔案名稱:POS权限设定单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ryr_file
(
ryr01       varchar2(10) DEFAULT ' ' NOT NULL, /*权限编号*/
ryr02       varchar2(20),            /*权限名称                               */
ryr03       number(5),               /*折扣                                   */
ryracti     varchar2(1) DEFAULT ' ' NOT NULL, /*有效否*/
ryrcrat     date,                    /*资料创建日                             */
ryrdate     date,                    /*最近更改日                             */
ryrgrup     varchar2(10),            /*资料所有群                             */
ryrmodu     varchar2(10),            /*资料更改者                             */
ryrorig     varchar2(10),            /*资料建立部门                           */
ryroriu     varchar2(10),            /*资料建立者                             */
ryrpos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
ryruser     varchar2(10)             /*资料所有者                             */
);

alter table ryr_file add  constraint ryr_pk primary key  (ryr01) enable validate;
grant select on ryr_file to tiptopgp;
grant update on ryr_file to tiptopgp;
grant delete on ryr_file to tiptopgp;
grant insert on ryr_file to tiptopgp;
grant index on ryr_file to public;
grant select on ryr_file to ods;
