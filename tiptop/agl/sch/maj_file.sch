/*
================================================================================
檔案代號:maj_file
檔案名稱:报表结构单身档 (FOR MVI)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table maj_file
(
maj01       varchar2(6) NOT NULL,    /*报表编号                               */
                                     /*報表編號                               */
maj02       number(9,4) NOT NULL,    /*项次                                   */
                                     /*項次                                   */
maj03       varchar2(1),             /*打印码                                 */
                                     /*列印碼                                 */
                                     /*0:金額,本行不印出, 但金額要作加總      */
                                     /*1:金額,本行正常印出                    */
                                     /*2:金額,本行金額不為0才印出             */
                                     /*3:底線,本行印出金額底線                */
                                     /*4:橫線,本行印出整排橫線                */
                                     /*5:金額,本行要印出, 但金額不作加總      */
                                     /*9:跳頁,本行印前跳頁                    */
                                     /*H:標題,本行印出標題或其它說明          */
                                     /*%:百分比,本行印出起始科目所輸入之序號/ */
                                     /*  截止科目所輸入之序號*100之值         */
maj04       number(5),               /*空行数                                 */
                                     /*空行數                                 */
maj05       number(5),               /*空格数                                 */
                                     /*空格數                                 */
maj06       varchar2(1),             /*1:科目之期初(借减贷) 2:科目之          */
                                     /*1:科目之期初(借減貸) 2:科目之當期異動  */
                                     /*3:科目之期末(借減貸)                   */
maj07       varchar2(1),             /*正常余额类型                           */
                                     /*正常餘額型態 (1.借餘/2.貸餘)           */
maj08       number(5),               /*合计阶数                               */
                                     /*合計階數                               */
maj09       varchar2(1),             /*+:合计加项 -:合计减项                  */
                                     /*+:合計加項 -:合計減項                  */
maj10       varchar2(1),             /*No Use                                 */
maj11       varchar2(1),             /*是否为百分比基准科目                   */
                                     /*是否為百分比基準科目 (Y/N)             */
                                     /*通常一個報表結構(BS,IS)應各設一基準科目*/
maj20       varchar2(255),           /*科目打印名称                           */
                                     /*科目列印名稱                           */
maj20e      varchar2(255),           /*额外打印名称                           */
                                     /*額外列印名稱                           */
maj21       varchar2(24),            /*起始科目编号                           */
                                     /*起始科目編號                           */
                                     /*當 maj03 matches '[0125]' 時, 本欄須輸入*/
maj22       varchar2(24),            /*截止科目编号                           */
                                     /*截止科目編號                           */
                                     /*當 maj03 matches '[0125]' 時, 本欄須輸入*/
maj23       varchar2(2),             /*类型                                   */
                                     /*型態                                   */
                                     /*當 maj03 matches '[0125]' 時, 本欄須輸入*/
                                     /*第一碼 1.資產負債表科目 2.損益表科目   */
                                     /*第二碼 1.左             2.右           */
maj24       varchar2(10),            /*起始部门编号                           */
                                     /*起始部門編號                           */
maj25       varchar2(10),            /*截止部门编号                           */
                                     /*截止部門編號                           */
maj26       number(5),               /*项次                                   */
                                     /*No use                                 */
maj27       varchar2(256),           /*计算公式(月)                           */
                                     /*No use                                 */
maj28       varchar2(256),           /*计算公式(年)                           */
                                     /*No use                                 */
maj29       varchar2(1),             /*No Use                                 */
maj30       varchar2(1),             /*No Use                                 */
maj32       varchar2(255),           /*科目打印名称                           */
maj33       varchar2(255),           /*额外打印名称                           */
maj34       varchar2(24),            /*起始科目编号                           */
maj35       varchar2(24),            /*截止科目编号                           */
maj31       varchar2(24),
maj12       varchar2(5)              /*项目类型                               */
);

alter table maj_file add  constraint maj_pk primary key  (maj01,maj02) enable validate;
grant select on maj_file to tiptopgp;
grant update on maj_file to tiptopgp;
grant delete on maj_file to tiptopgp;
grant insert on maj_file to tiptopgp;
grant index on maj_file to public;
grant select on maj_file to ods;
