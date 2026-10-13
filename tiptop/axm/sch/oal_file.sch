/*
================================================================================
檔案代號:oal_file
檔案名稱:多角贸易计价公式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oal_file
(
oal01       varchar2(2) NOT NULL,    /*通路代码                               */
                                     /*通路代碼                               */
oal02       date NOT NULL,           /*生效日期                               */
oal03       varchar2(1),             /*计价基准                               */
                                     /*Pricing Base                           */
                                     /*  1:By Source Plant                    */
                                     /*  2:By Upper Vender                    */
oal11       varchar2(1),             /*计算方式一                             */
                                     /*計算方式一                             */
                                     /*  1:按比率計算                         */
                                     /*  2:計算公式A (取固定價格)             */
                                     /*  3:計算公式B (若來源=0,則給0,否則取固定*/
                                     /*               價格                    */
oal12       number(9,4),             /*计价比率                               */
                                     /*計價比率(百分數) ex 0.06輸入6.00       */
                                     /*  本計價比率均以訂單為計算基礎         */
oal21       varchar2(1),             /*计算方式二                             */
                                     /*計算方式二                             */
oal22       number(9,4),             /*计价比率二                             */
                                     /*計價比率二                             */
oal31       varchar2(1),             /*计算方式三                             */
                                     /*計算方式三                             */
oal32       number(9,4),             /*计价比率三                             */
                                     /*計價比率三                             */
oal41       varchar2(1),             /*计算方式四                             */
                                     /*計算方式四                             */
oal42       number(9,4),             /*计价比率四                             */
                                     /*計價比率四                             */
oal51       varchar2(1),             /*计算方式五                             */
                                     /*計算方式五                             */
oal52       number(9,4),             /*计价比率五                             */
                                     /*計價比率五                             */
oal61       varchar2(1),             /*计算方式六                             */
                                     /*計算方式六                             */
oal62       number(9,4)              /*计价比率六                             */
                                     /*計價比率六                             */
);

alter table oal_file add  constraint oal_pk primary key  (oal01,oal02) enable validate;
grant select on oal_file to tiptopgp;
grant update on oal_file to tiptopgp;
grant delete on oal_file to tiptopgp;
grant insert on oal_file to tiptopgp;
grant index on oal_file to public;
grant select on oal_file to ods;
