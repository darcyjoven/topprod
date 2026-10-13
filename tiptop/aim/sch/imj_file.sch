/*
================================================================================
檔案代號:imj_file
檔案名稱:ABC计算记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table imj_file
(
imj01       date NOT NULL,           /*日期                                   */
imj02       varchar2(8) NOT NULL,    /*时间                                   */
                                     /*時間                                   */
imj03       varchar2(10),            /*人员                                   */
                                     /*人員                                   */
imj04       varchar2(1),             /*ABC计算方式                            */
                                     /*ABC計算方式                            */
imj05       number(5),               /*ABC计算年度                            */
                                     /*ABC計算年度                            */
imj06       number(5),               /*ABC计算期间                            */
                                     /*ABC計算期間                            */
imj07       varchar2(1),             /*排定标准                               */
                                     /*排定標準                               */
imj08       varchar2(20),            /*分群码范围                             */
                                     /*分群碼範圍                             */
imj09       number(5),               /*计算期间数                             */
                                     /*計算期間數                             */
imj10       number(5),               /*A 类百分比                             */
                                     /*A 類百分比                             */
imj11       number(5),               /*B 类百分比                             */
                                     /*B 類百分比                             */
imjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table imj_file add  constraint imj_pk primary key  (imj01,imj02) enable validate;
grant select on imj_file to tiptopgp;
grant update on imj_file to tiptopgp;
grant delete on imj_file to tiptopgp;
grant insert on imj_file to tiptopgp;
grant index on imj_file to public;
grant select on imj_file to ods;
