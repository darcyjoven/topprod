/*
================================================================================
檔案代號:amb_file
檔案名稱:发票字首档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table amb_file
(
amb01       number(5) NOT NULL,      /*发票年                                 */
                                     /*發票年                                 */
amb02       number(5) NOT NULL,      /*发票月-起始                            */
                                     /*發票月-起始                            */
amb03       varchar2(2) NOT NULL,    /*字首                                   */
                                     /*字軌                                   */
amb04       varchar2(2) NOT NULL,    /*格式                                   */
                                     /*格式     (21,22,25)                    */
amb05       number(10),              /*起始号码                               */
                                     /*起始號碼                               */
amb06       number(10),              /*结束号码                               */
                                     /*結束號碼                               */
amb07       number(5) NOT NULL,      /*发票月-截止                            */
                                     /*發票月-截止 99/02/23 modify            */
amb08       varchar2(1)              /*No Use                                 */
);

create        index amb_02 on amb_file (amb01,amb02,amb07);
alter table amb_file add  constraint amb_pk primary key  (amb01,amb02,amb03,amb04,amb07) enable validate;
grant select on amb_file to tiptopgp;
grant update on amb_file to tiptopgp;
grant delete on amb_file to tiptopgp;
grant insert on amb_file to tiptopgp;
grant index on amb_file to public;
grant select on amb_file to ods;
