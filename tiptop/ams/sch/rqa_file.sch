/*
================================================================================
檔案代號:rqa_file
檔案名稱:每日资源维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rqa_file
(
rqa01       varchar2(10) NOT NULL,   /*资源编号                               */
                                     /*資源代號                               */
rqa02       varchar2(10) NOT NULL,   /*版本                                   */
rqa03       date NOT NULL,           /*起始日期                               */
rqa04       date NOT NULL,           /*截止日期                               */
rqa05       number(15,3),            /*当日产能                               */
                                     /*當日產能                               */
rqa06       number(15,3),            /*已耗产能                               */
                                     /*已秏產能                               */
rqa07       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
rqa08       varchar2(1)              /*No Use                                 */
);

alter table rqa_file add  constraint rqa_pk primary key  (rqa01,rqa02,rqa03,rqa04) enable validate;
grant select on rqa_file to tiptopgp;
grant update on rqa_file to tiptopgp;
grant delete on rqa_file to tiptopgp;
grant insert on rqa_file to tiptopgp;
grant index on rqa_file to public;
grant select on rqa_file to ods;
