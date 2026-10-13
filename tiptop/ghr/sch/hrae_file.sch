/*
================================================================================
檔案代號:hrae_file
檔案名稱:年龄司龄区间档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrae_file
(
hrae00      varchar2(1) NOT NULL,    /*区间类型                               */
hrae01      varchar2(10) NOT NULL,   /*区间编码                               */
hrae02      varchar2(50),            /*区间名称                               */
hrae03      number(15,2),            /*区间下限                               */
hrae04      number(15,2),            /*区间上限                               */
hrae05      varchar2(255),           /*备注                                   */
hraeuser    varchar2(10),            /*资料所有者                             */
hraegrup    varchar2(10),            /*资料所有群                             */
hraemodu    varchar2(10),            /*资料修改者                             */
hraedate    date,                    /*最近修改日                             */
hraeorig    varchar2(10),            /*资料建立者                             */
hraeoriu    varchar2(10)             /*资料建立部门                           */
);

alter table hrae_file add  constraint tpc_hrae_pk primary key  (hrae00,hrae01) enable validate;
grant select on hrae_file to tiptopgp;
grant update on hrae_file to tiptopgp;
grant delete on hrae_file to tiptopgp;
grant insert on hrae_file to tiptopgp;
grant index on hrae_file to public;
grant select on hrae_file to ods;
