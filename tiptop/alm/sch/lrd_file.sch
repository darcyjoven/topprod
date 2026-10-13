/*
================================================================================
檔案代號:lrd_file
檔案名稱:会员换赠设定生效范围档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lrd_file
(
lrd01       varchar2(20) DEFAULT ' ' NOT NULL, /*会员换赠方案编号*/
lrd02       varchar2(10) DEFAULT ' ' NOT NULL, /*生效营运中心*/
lrdacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lrddate     date,                    /*最近更改日                             */
lrdgrup     varchar2(10),            /*资料所有群                             */
lrdmodu     varchar2(10),            /*资料更改者                             */
lrdorig     varchar2(10),            /*资料建立部门                           */
lrdoriu     varchar2(10),            /*资料建立者                             */
lrduser     varchar2(10)             /*资料所有者                             */
);

alter table lrd_file add  constraint lrd_pk primary key  (lrd01,lrd02) enable validate;
grant select on lrd_file to tiptopgp;
grant update on lrd_file to tiptopgp;
grant delete on lrd_file to tiptopgp;
grant insert on lrd_file to tiptopgp;
grant index on lrd_file to public;
grant select on lrd_file to ods;
