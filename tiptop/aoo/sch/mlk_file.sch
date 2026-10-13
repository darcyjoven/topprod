/*
================================================================================
檔案代號:mlk_file
檔案名稱:javamail缺省收件人
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mlk_file
(
mlk01       varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式代號(program code)                 */
mlk02       number(5) NOT NULL,      /*序号                                   */
mlk03       varchar2(1),             /*1:收件者 2: 副本 3: 密件副本           */
                                     /* 1:收件者 2: 副本 3: 密件副本          */
mlk04       varchar2(80),            /*MAIL  address                          */
mlk05       varchar2(40),            /*姓名                                   */
mlk06       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
mlk07       varchar2(1)              /*报表mail文档格式                       */
);

alter table mlk_file add  constraint mlk_pk primary key  (mlk01,mlk02) enable validate;
grant select on mlk_file to tiptopgp;
grant update on mlk_file to tiptopgp;
grant delete on mlk_file to tiptopgp;
grant insert on mlk_file to tiptopgp;
grant index on mlk_file to public;
grant select on mlk_file to ods;
