/*
================================================================================
檔案代號:hrdpb_file
檔案名稱:申请稳定薪资信息
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdpb_file
(
hrdpb01     varchar2(10) NOT NULL,   /*流水码                                 */
hrdpb02     varchar2(20) NOT NULL,   /*稳定薪资项参数                         */
hrdpb03     number(15,2),            /*参数值                                 */
hrdpb04     date NOT NULL,           /*生效日期                               */
hrdpb05     date,                    /*失效日期                               */
hrdpb06     varchar2(255),           /*备注                                   */
hrdpbud01   varchar2(255),
hrdpbud02   varchar2(40),
hrdpbud03   varchar2(40),
hrdpbud04   varchar2(40),
hrdpbud05   varchar2(40),
hrdpbud06   varchar2(40),
hrdpbud07   number(15,3),
hrdpbud08   number(15,3),
hrdpbud09   number(15,3),
hrdpbud10   number(10),
hrdpbud11   number(10),
hrdpbud12   number(10),
hrdpbud13   date,
hrdpbud14   date,
hrdpbud15   date
);

alter table hrdpb_file add  constraint hrdpb_pk primary key  (hrdpb01,hrdpb02,hrdpb04) enable validate;
grant select on hrdpb_file to tiptopgp;
grant update on hrdpb_file to tiptopgp;
grant delete on hrdpb_file to tiptopgp;
grant insert on hrdpb_file to tiptopgp;
grant index on hrdpb_file to public;
grant select on hrdpb_file to ods;
