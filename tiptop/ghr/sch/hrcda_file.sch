/*
================================================================================
檔案代號:hrcda_file
檔案名稱:假勤单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcda_file
(
hrcda01     number(5) NOT NULL,      /*项次                                   */
hrcda02     varchar2(20) NOT NULL,   /*请假单号                               */
hrcda03     varchar2(20),            /*假勤项目编号                           */
hrcda04     varchar2(10),            /*员工ID                                 */
hrcda05     date,                    /*开始日期                               */
hrcda06     varchar2(5),             /*开始时间                               */
hrcda07     date,                    /*结束日期                               */
hrcda08     varchar2(5),             /*结束时间                               */
hrcda09     number(15,3),            /*请假时长                               */
hrcda10     varchar2(20),            /*单位                                   */
hrcda11     number(15,3),            /*请假分钟数                             */
hrcda12     number(15,3),            /*请假小时数                             */
hrcda13     number(15,3),            /*请假天数                               */
hrcda14     number(15,3),            /*班段时长/小时                          */
hrcda15     varchar2(255),           /*备注                                   */
hrcda16     varchar2(1),             /*已撤销假                               */
hrcda17     varchar2(1),             /*数据类型                               */
                                     /*1：特殊假、2：年假、3：出差、4：其他假 */
hrcda18     varchar2(20)             /*No Use                                 */
);

alter table hrcda_file add  constraint tpc_hrcda_pk primary key  (hrcda01,hrcda02) enable validate;
grant select on hrcda_file to tiptopgp;
grant update on hrcda_file to tiptopgp;
grant delete on hrcda_file to tiptopgp;
grant insert on hrcda_file to tiptopgp;
grant index on hrcda_file to public;
grant select on hrcda_file to ods;
