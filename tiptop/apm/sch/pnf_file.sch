/*
================================================================================
檔案代號:pnf_file
檔案名稱:请购变更单身头
檔案目的:
上游檔案:pne_file
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnf_file
(
pnf01       varchar2(20) DEFAULT ' ' NOT NULL, /*请购单号*/
pnf02       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
pnf03       number(5) DEFAULT '0' NOT NULL, /*请购单项次*/
pnf04b      varchar2(40),            /*变更前料号                             */
pnf04a      varchar2(40),            /*变更后料号                             */
pnf041b     varchar2(120),           /*变更前品名规格                         */
pnf041a     varchar2(120),           /*变更后品名规格                         */
pnf07b      varchar2(4),             /*变更前请购单位                         */
pnf07a      varchar2(4),             /*变更后请购单位                         */
pnf20b      number(15,3),            /*变更前订购量                           */
pnf20a      number(15,3),            /*变更后订购量                           */
pnf33b      date,                    /*变更前原始交货日期                     */
pnf33a      date,                    /*变更后原始交货日期                     */
pnf80b      varchar2(4),             /*变更前单位一                           */
pnf80a      varchar2(4),             /*变更后单位一                           */
pnf81b      number(20,8),            /*变更前单位一换算率(与采购单            */
pnf81a      number(20,8),            /*變更后單位一換算率(與採購單            */
pnf82b      number(15,3),            /*变更前单位一数量                       */
pnf82a      number(15,3),            /*变更后单位一数量                       */
pnf83b      varchar2(4),             /*变更前单位二                           */
pnf83a      varchar2(4),             /*變更後單位二                           */
pnf84b      number(20,8),            /*变更前单位二换算率(与采购单            */
pnf84a      number(20,8),            /*變更后單位二換算率(與採購單            */
pnf85b      number(15,3),            /*变更前单位二数量                       */
pnf85a      number(15,3),            /*變更後單位二數量                       */
pnf86b      varchar2(4),             /*变更前计价单位                         */
pnf86a      varchar2(4),             /*變更後計價單位                         */
pnf87b      number(15,3),            /*变更前计价数量                         */
pnf87a      number(15,3),            /*變更後計價數量                         */
pnf41b      varchar2(20),            /*變更前PLP-NO.                          */
pnf41a      varchar2(20),            /*變更後PLP-NO.                          */
pnf12b      varchar2(10),            /*變更前專案代號                         */
pnf12a      varchar2(10),            /*變更後專案代號                         */
pnf121b     varchar2(30),            /*變更前WBS編碼                          */
pnf121a     varchar2(30),            /*變更後WBS編碼                          */
pnf122b     varchar2(4),             /*變更前活動代號                         */
pnf122a     varchar2(4),             /*變更後活動代號                         */
pnf50       varchar2(255),           /*备注                                   */
pnfud01     varchar2(255),           /*自订字段-Textedit                      */
pnfud02     varchar2(40),            /*自订字段-文字                          */
pnfud03     varchar2(40),            /*自订字段-文字                          */
pnfud04     varchar2(40),            /*自订字段-文字                          */
pnfud05     varchar2(40),            /*自订字段-文字                          */
pnfud06     varchar2(40),            /*自订字段-文字                          */
pnfud07     number(15,3),            /*自订字段-数值                          */
pnfud08     number(15,3),            /*自订字段-数值                          */
pnfud09     number(15,3),            /*自订字段-数值                          */
pnfud10     number(10),              /*自订字段-整数                          */
pnfud11     number(10),              /*自订字段-整数                          */
pnfud12     number(10),              /*自订字段-整数                          */
pnfud13     date,                    /*自订字段-日期                          */
pnfud14     date,                    /*自订字段-日期                          */
pnfud15     date,                    /*自订字段-日期                          */
pnfplant    varchar2(10),            /*所属工厂                               */
pnflegal    varchar2(10)             /*所属法人                               */
);

alter table pnf_file add  constraint pnf_pk primary key  (pnf01,pnf02,pnf03) enable validate;
grant select on pnf_file to tiptopgp;
grant update on pnf_file to tiptopgp;
grant delete on pnf_file to tiptopgp;
grant insert on pnf_file to tiptopgp;
grant index on pnf_file to public;
grant select on pnf_file to ods;
