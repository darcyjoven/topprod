/*
================================================================================
檔案代號:sgui_file
檔案名稱:工单工艺变更档
檔案目的:工单工艺变更单身档(行业别架构)
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgui_file
(
sgui01      varchar2(40) NOT NULL,   /*工单单号                               */
sgui02      number(5) NOT NULL,      /*变更序号                               */
sgui04      number(5) NOT NULL,      /*工艺序号                               */
sguislk01   varchar2(1),             /*原裁片管理否                           */
sguislk02   number(8,4),             /*原现实工时                             */
sguislk03   number(20,6),            /*原标准工价                             */
sguislk04   number(20,6),            /*原现实工价                             */
sguislk05   varchar2(1),             /*新裁片管理否                           */
sguislk06   number(8,4),             /*新现实工时                             */
sguislk07   number(20,6),            /*新标准工价                             */
sguislk08   number(20,6),            /*新现实工价                             */
sguiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
sguilegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table sgui_file add  constraint sgui_pk primary key  (sgui01,sgui02,sgui04) enable validate;
grant select on sgui_file to tiptopgp;
grant update on sgui_file to tiptopgp;
grant delete on sgui_file to tiptopgp;
grant insert on sgui_file to tiptopgp;
grant index on sgui_file to public;
grant select on sgui_file to ods;
