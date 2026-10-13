/*
================================================================================
檔案代號:sta_file
檔案名稱:标准成本主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sta_file
(
sta01       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
sta02       varchar2(1),             /*成本计算方式                           */
                                     /*成本計算方式 0/1/2                     */
                                     /* 0.不重新計算  1.重新計算(不考慮損耗率)*/
                                     /* 2.重新計算(考慮損耗率)                */
sta03       number(15,6),            /*标准工时                               */
                                     /*標準工時                               */
sta04       number(20,6),            /*本阶直接材料成本                       */
                                     /*本階直接材料成本                       */
sta05       number(10,4),            /*本阶直接人工工资率                     */
                                     /*本階直接人工工資率                     */
sta06       number(10,4),            /*本阶间接制造费用分摊率                 */
                                     /*本階間接製造費用分攤率                 */
sta06a      number(20,6),            /*本阶其他制造费用                       */
                                     /*本階其他製造費用                       */
sta07       varchar2(10),            /*主工艺                                 */
                                     /*主製程                                 */
sta08       number(20,6),            /*加工费用                               */
                                     /*加工費用                               */
sta09       number(5),               /*内制外包率                             */
                                     /*內製外包率                             */
sta10       number(5),               /*呆滞比率                               */
                                     /*呆滯比率                               */
sta11       varchar2(1)              /*呆滞料否--LCM使用                      */
                                     /*呆滯料否--LCM使用                      */
);

alter table sta_file add  constraint sta_pk primary key  (sta01) enable validate;
grant select on sta_file to tiptopgp;
grant update on sta_file to tiptopgp;
grant delete on sta_file to tiptopgp;
grant insert on sta_file to tiptopgp;
grant index on sta_file to public;
grant select on sta_file to ods;
