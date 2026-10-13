/*
================================================================================
檔案代號:nmc_file
檔案名稱:银行存提异动码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmc_file
(
nmc01       varchar2(2) NOT NULL,    /*银行存提异动码                         */
                                     /*銀行存提異動碼                         */
nmc02       varchar2(80),            /*核算项名称                             */
                                     /*異動碼名稱                             */
nmc03       varchar2(1),             /*存提款                                 */
                                     /*存提別: 1:存(借)  2:提(貸)             */
nmc04       varchar2(24),            /*缺省对方科目                           */
                                     /*預設對方科目                           */
nmc05       varchar2(4),             /*缺省现金变动码                         */
                                     /*預設現金變動碼                         */
nmcacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
nmcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
nmcgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
nmcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
nmcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
nmc041      varchar2(24),            /*缺省对方科目二                         */
nmcorig     varchar2(10),            /*资料建立部门                           */
nmcoriu     varchar2(10)             /*资料建立者                             */
);

alter table nmc_file add  constraint nmc_pk primary key  (nmc01) enable validate;
grant select on nmc_file to tiptopgp;
grant update on nmc_file to tiptopgp;
grant delete on nmc_file to tiptopgp;
grant insert on nmc_file to tiptopgp;
grant index on nmc_file to public;
grant select on nmc_file to ods;
