/*
================================================================================
檔案代號:zj_file
檔案名稱:批次运行指令明细档  BATCH INSTRUCTIO
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zj_file
(
zj01        varchar2(10) NOT NULL,   /*批次编号                               */
                                     /*批次編號                               */
zj02        number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
zj03        varchar2(10),            /*指令编号                               */
                                     /*指令編號                               */
zj041       varchar2(72),            /*指令内容 ( 一 )                        */
                                     /*指令內容 ( 一 )                        */
zj042       varchar2(72),            /*指令内容 ( 二 )                        */
                                     /*指令內容 ( 二 )                        */
zj043       varchar2(72)             /*指令内容 ( 三 )                        */
                                     /*指令內容 ( 三 )                        */
);

alter table zj_file add  constraint zj_pk primary key  (zj01,zj02) enable validate;
grant select on zj_file to tiptopgp;
grant update on zj_file to tiptopgp;
grant delete on zj_file to tiptopgp;
grant insert on zj_file to tiptopgp;
grant index on zj_file to public;
grant select on zj_file to ods;
