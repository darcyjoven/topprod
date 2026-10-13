/*
================================================================================
檔案代號:pob_file
檔案名稱:代采买多角贸易计价公式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pob_file
(
pob01       varchar2(2) NOT NULL,    /*通路代码                               */
                                     /*通路代碼                               */
pob02       date NOT NULL,           /*生效日期                               */
pob03       varchar2(1),             /*计价基准                               */
                                     /*計價基準                               */
                                     /*  1:依來源工廠                         */
                                     /*  2:依上層廠商                         */
pob11       varchar2(1),             /*计算方式一                             */
                                     /*Calculation Method 1                   */
                                     /*  1:By Ratio Calculates                */
                                     /*  2:Calculational Formula A (Take Fixed Price)*/
                                     /*  3:Calculational Formula B (If Source Equal To 0,Set 0,Otherwise Take Fixed Price*/
pob12       number(9,4),             /*计价比率                               */
                                     /*Pricing Ratio(%) ex Enter 6.00 for 0.06         The Pricing Ratio Take Order As The Base Of Calculating*/
pob21       varchar2(1),             /*计算方式二                             */
                                     /*計算方式二                             */
pob22       number(9,4),             /*计价比率二                             */
                                     /*計價比率二                             */
pob31       varchar2(1),             /*计算方式三                             */
                                     /*計算方式三                             */
pob32       number(9,4),             /*计价比率三                             */
                                     /*計價比率三                             */
pob41       varchar2(1),             /*计算方式四                             */
                                     /*計算方式四                             */
pob42       number(9,4),             /*计价比率四                             */
                                     /*計價比率四                             */
pob51       varchar2(1),             /*计算方式五                             */
                                     /*計算方式五                             */
pob52       number(9,4),             /*计价比率五                             */
                                     /*計價比率五                             */
pob61       varchar2(1),             /*计算方式六                             */
                                     /*計算方式六                             */
pob62       number(9,4)              /*计价比率六                             */
                                     /*計價比率六                             */
);

alter table pob_file add  constraint pob_pk primary key  (pob01,pob02) enable validate;
grant select on pob_file to tiptopgp;
grant update on pob_file to tiptopgp;
grant delete on pob_file to tiptopgp;
grant insert on pob_file to tiptopgp;
grant index on pob_file to public;
grant select on pob_file to ods;
