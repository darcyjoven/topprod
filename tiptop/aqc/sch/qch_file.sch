/*
================================================================================
檔案代號:qch_file
檔案名稱:特殊检验水准样本代码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qch_file
(
qch01       number(10) NOT NULL,     /*起始批量                               */
qch02       number(10) NOT NULL,     /*截止批量                               */
qch03       varchar2(1) NOT NULL,    /*样本字号                               */
                                     /*樣本字號                               */
qch04       number(5),               /*正常检验样本收                         */
                                     /*正常檢驗樣本收                         */
qch05       number(5),               /*加严检验样本收                         */
                                     /*加嚴檢驗樣本收                         */
qch06       number(5),               /*减量检验样本收                         */
                                     /*減量檢驗樣本收                         */
qch07       varchar2(1) NOT NULL     /*级数                                   */
                                     /*級數                                   */
);

alter table qch_file add  constraint qch_pk primary key  (qch01,qch02,qch03,qch07) enable validate;
grant select on qch_file to tiptopgp;
grant update on qch_file to tiptopgp;
grant delete on qch_file to tiptopgp;
grant insert on qch_file to tiptopgp;
grant index on qch_file to public;
grant select on qch_file to ods;
