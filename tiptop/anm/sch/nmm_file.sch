/*
================================================================================
檔案代號:nmm_file
檔案名稱:借款状况资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nmm_file
(
nmm01       number(5) NOT NULL,      /*资料年度                               */
                                     /*資料年度                               */
nmm02       number(5) NOT NULL,      /*资料月份                               */
                                     /*資料月份                               */
nmm03       number(20,6) DEFAULT '0' NOT NULL, /*利率*/
                                     /*月利率                   #No:7354      */
nmm04       number(20,6),            /*利息支出                               */
nmmacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
nmmuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
nmmgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
nmmmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
nmmdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
nmmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
nmmoriu     varchar2(10),            /*资料建立者                             */
nmmorig     varchar2(10)             /*资料建立部门                           */
);

alter table nmm_file add  constraint nmm_pk primary key  (nmm01,nmm02) enable validate;
grant select on nmm_file to tiptopgp;
grant update on nmm_file to tiptopgp;
grant delete on nmm_file to tiptopgp;
grant insert on nmm_file to tiptopgp;
grant index on nmm_file to public;
grant select on nmm_file to ods;
