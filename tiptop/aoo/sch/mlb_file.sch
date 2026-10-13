/*
================================================================================
檔案代號:mlb_file
檔案名稱:报表转发人员单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mlb_file
(
mlb01       varchar2(10) NOT NULL,   /*报表编号                               */
                                     /*報表代號                               */
mlb02       number(5) NOT NULL,      /*顺序                                   */
                                     /*順序                                   */
mlb03       varchar2(10) NOT NULL,   /*查阅人员                               */
                                     /*查閱人員                               */
mlb04       varchar2(255)            /*备注                                   */
                                     /*備註                                   */
);

alter table mlb_file add  constraint mlb_pk primary key  (mlb01,mlb02,mlb03) enable validate;
grant select on mlb_file to tiptopgp;
grant update on mlb_file to tiptopgp;
grant delete on mlb_file to tiptopgp;
grant insert on mlb_file to tiptopgp;
grant index on mlb_file to public;
grant select on mlb_file to ods;
