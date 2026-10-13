/*
================================================================================
檔案代號:hrdpc_file
檔案名稱:申请薪点值信息
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdpc_file
(
hrdpc01     varchar2(10) NOT NULL,   /*流水码                                 */
hrdpc02     varchar2(20) NOT NULL,   /*薪点表ID                               */
hrdpc03     varchar2(20),            /*项目                                   */
hrdpc04     varchar2(20),            /*等级                                   */
hrdpc05     number(15,2),            /*薪点值                                 */
hrdpc06     date NOT NULL,           /*生效日期                               */
hrdpc07     date,                    /*失效日期                               */
hrdpc08     varchar2(255),           /*备注                                   */
hrdpcud01   varchar2(255),
hrdpcud02   varchar2(40),
hrdpcud03   varchar2(40),
hrdpcud04   varchar2(40),
hrdpcud05   varchar2(40),
hrdpcud06   varchar2(40),
hrdpcud07   number(15,3),
hrdpcud08   number(15,3),
hrdpcud09   number(15,3),
hrdpcud10   number(10),
hrdpcud11   number(10),
hrdpcud12   number(10),
hrdpcud13   date,
hrdpcud14   date,
hrdpcud15   date
);

alter table hrdpc_file add  constraint hrdpc_pk primary key  (hrdpc01,hrdpc02,hrdpc06) enable validate;
grant select on hrdpc_file to tiptopgp;
grant update on hrdpc_file to tiptopgp;
grant delete on hrdpc_file to tiptopgp;
grant insert on hrdpc_file to tiptopgp;
grant index on hrdpc_file to public;
grant select on hrdpc_file to ods;
