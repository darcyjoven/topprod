/*
================================================================================
檔案代號:agb_file
檔案名稱:属性群组资料单身档
檔案目的:记录多属性料件机制中定义的属性群组资料
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table agb_file
(
agb01       varchar2(10) NOT NULL,   /*属性群组代码                           */
agb02       number(10) NOT NULL,     /*顺序                                   */
agb03       varchar2(10) NOT NULL,   /*明细属性                               */
agbslk01    varchar2(1),             /*影响缩放比例                           */
agbslk02    varchar2(1),             /*度量属性否                             */
agbslk03    varchar2(1),             /*洗水色属性否                           */
agb04       varchar2(1)              /*属性维数                               */
);

alter table agb_file add  constraint agb_pk primary key  (agb01,agb02) enable validate;
grant select on agb_file to tiptopgp;
grant update on agb_file to tiptopgp;
grant delete on agb_file to tiptopgp;
grant insert on agb_file to tiptopgp;
grant index on agb_file to public;
grant select on agb_file to ods;
