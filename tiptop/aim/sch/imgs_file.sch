/*
================================================================================
檔案代號:imgs_file
檔案名稱:批号库存明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table imgs_file
(
imgs01      varchar2(40) NOT NULL,   /*料件编号                               */
imgs02      varchar2(10) NOT NULL,   /*仓库                                   */
imgs03      varchar2(10) NOT NULL,   /*库位                                   */
imgs04      varchar2(24) NOT NULL,   /*批号                                   */
imgs05      varchar2(30) NOT NULL,   /*序号                                   */
imgs06      varchar2(30) NOT NULL,   /*制造批号                               */
imgs07      varchar2(4),             /*库存单位                               */
imgs08      number(15,3),            /*数量                                   */
imgs09      date,                    /*制造日期                               */
imgs10      varchar2(1),             /*归属类型                               */
imgs11      varchar2(20) NOT NULL,   /*归属单号                               */
imgsplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
imgslegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table imgs_file add  constraint imgs_pk primary key  (imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,imgs11) enable validate;
grant select on imgs_file to tiptopgp;
grant update on imgs_file to tiptopgp;
grant delete on imgs_file to tiptopgp;
grant insert on imgs_file to tiptopgp;
grant index on imgs_file to public;
grant select on imgs_file to ods;
