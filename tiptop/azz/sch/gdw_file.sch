/*
================================================================================
檔案代號:gdw_file
檔案名稱:GRW報表樣版記錄檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdw_file
(
gdw01       varchar2(20) DEFAULT ' ' NOT NULL, /*程序编号*/
gdw02       varchar2(20) DEFAULT ' ' NOT NULL, /*样板编号*/
gdw03       varchar2(1) DEFAULT ' ' NOT NULL, /*客制否*/
gdw04       varchar2(10) DEFAULT ' ' NOT NULL, /*权限类型*/
gdw05       varchar2(10) DEFAULT ' ' NOT NULL,
gdw06       varchar2(10) DEFAULT ' ' NOT NULL, /*行业别*/
gdw07       number(5) DEFAULT '1' NOT NULL, /*序号*/
gdw08       number(10) DEFAULT '1' NOT NULL,
gdw09       varchar2(100),
gdw10       varchar2(1) DEFAULT 'N' NOT NULL,
gdw11       varchar2(1) DEFAULT ' ' NOT NULL,
gdw12       number(5),
gdw13       number(5),
gdwdate     date,                    /*最近更改日                             */
gdwgrup     varchar2(10),            /*资料所有群                             */
gdwmodu     varchar2(10),            /*资料更改者                             */
gdworig     varchar2(10),            /*资料建立部门                           */
gdworiu     varchar2(10),            /*资料建立者                             */
gdwuser     varchar2(10),            /*资料所有者                             */
gdw14       varchar2(1) DEFAULT 'N' NOT NULL, /*打印签核*/
gdw15       varchar2(1) DEFAULT '1' NOT NULL, /*打印签核位置*/
gdw16       number(10) DEFAULT '20', /*报表执行逾期时间(分)                   */
gdw17       varchar2(1) DEFAULT ' ' NOT NULL
);

create unique index gdw_01 on gdw_file (gdw08);
alter table gdw_file add  constraint gdw_pk primary key  (gdw01,gdw02,gdw03,gdw04,gdw05,gdw06,gdw07) enable validate;
grant select on gdw_file to tiptopgp;
grant update on gdw_file to tiptopgp;
grant delete on gdw_file to tiptopgp;
grant insert on gdw_file to tiptopgp;
grant index on gdw_file to public;
grant select on gdw_file to ods;
