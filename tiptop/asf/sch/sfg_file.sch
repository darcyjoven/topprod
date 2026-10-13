/*
================================================================================
檔案代號:sfg_file
檔案名稱:工作站投入/产出档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sfg_file
(
sfg01       varchar2(10) NOT NULL,   /*工作站编号                             */
                                     /*Work Station Code                      */
                                     /*The code of work place maybe one of the follow:*/
                                     /*Plant Center/Workshop/Worksite         */
                                     /*sma88                                  */
sfg02       date NOT NULL,           /*该周周一                               */
                                     /*該週週一                               */
                                     /*以該週第一天（星期一）為其該週代表日   */
                                     /*系統處理時將以此為'Index field'        */
sfg03       date,                    /*该周周日                               */
                                     /*該週週日                               */
sfg04       number(15,3),            /*计算投入量或小时                       */
                                     /*計算投入量或小時 (未發放)              */
sfg05       number(15,3),            /*计算投入量或小时                       */
                                     /*計算投入量或小時 (已發放)              */
sfg06       number(15,3),            /*计算产出量或小时                       */
                                     /*計算產出量或小時                       */
sfg07       varchar2(1)              /*控制时间                               */
                                     /*控制時間                               */
                                     /*1.以小時為基礎                         */
                                     /*2.以數量為基礎                         */
);

create        index sfg_02 on sfg_file (sfg01);
alter table sfg_file add  constraint sfg_pk primary key  (sfg01,sfg02) enable validate;
grant select on sfg_file to tiptopgp;
grant update on sfg_file to tiptopgp;
grant delete on sfg_file to tiptopgp;
grant insert on sfg_file to tiptopgp;
grant index on sfg_file to public;
grant select on sfg_file to ods;
