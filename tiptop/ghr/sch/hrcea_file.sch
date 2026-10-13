/*
================================================================================
檔案代號:hrcea_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcea_file
(
hrcea01     number(15) NOT NULL,     /*出差编号                               */
hrcea02     number(5) NOT NULL,      /*编号                                   */
hrcea03     varchar2(20) NOT NULL,   /*出发地                                 */
hrcea04     varchar2(20) NOT NULL,   /*目的地                                 */
hrcea05     date NOT NULL,           /*出发时间                               */
hrcea06     date NOT NULL,           /*到达时间                               */
hrcea07     varchar2(20) NOT NULL,   /*费用类型                               */
hrcea08     varchar2(20),            /*交通工具                               */
hrcea09     number(5,2),             /*房费/元/间                             */
hrcea10     number(5,2),             /*核算量                                 */
hrcea11     number(5,2) NOT NULL,    /*核算费用                               */
hrcea12     varchar2(255),           /*备注                                   */
hrcea13     varchar2(60)             /*费用人员ID                             */
);

alter table hrcea_file add  constraint tpc_hrcea_pk primary key  (hrcea01,hrcea02) enable validate;
grant select on hrcea_file to tiptopgp;
grant update on hrcea_file to tiptopgp;
grant delete on hrcea_file to tiptopgp;
grant insert on hrcea_file to tiptopgp;
grant index on hrcea_file to public;
grant select on hrcea_file to ods;
