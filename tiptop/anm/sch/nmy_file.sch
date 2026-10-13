/*
================================================================================
檔案代號:nmy_file
檔案名稱:ANM-单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmy_file
(
nmyslip     varchar2(5) NOT NULL,    /*单    别                               */
                                     /*單    別                               */
nmydesc     varchar2(80),            /*单据名称                               */
                                     /*單據名稱                               */
nmyauno     varchar2(1),             /*自动编号否                             */
                                     /*自動編號否                             */
                                     /*正確值 Y/N                             */
                                     /*Y: 是                                  */
                                     /*N: 否                                  */
nmymxno     varchar2(20),            /*已用单号                               */
                                     /*已用單號                               */
nmykind     varchar2(2),             /*单据性质                               */
                                     /*單據性質                               */
                                     /*1.應付票據單號 2.應收票據單號 3.收支單號*/
                                     /*4.融資 5.中長貸 6.還息單號 7.還款單號  */
                                     /*8.投資單 9.外匯交易A.應付異動 B.應收異動*/
                                     /*C.平倉單 D.利息收入 E.定存到期         */
                                     /*F.投資購買          G.定存單           */
nmyapr      varchar2(1),             /*签核处理                               */
                                     /*簽核處理                               */
                                     /*正確值 Y/N                             */
                                     /*Y: 是                                  */
                                     /*N: 否                                  */
nmyatsg     varchar2(1),             /*是否自动赋予签核等级                   */
                                     /*是否自動賦予簽核等級                   */
                                     /*正確值 Y/N                             */
                                     /*Y: 是                                  */
                                     /*N: 否                                  */
nmysign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
nmydays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
nmyprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
nmyprint    varchar2(1),             /*立即打印                               */
                                     /*立即列印                               */
                                     /*單據輸入時是否立即列印                 */
nmydmy1     varchar2(1),             /*立即审核                               */
                                     /*立即確認                               */
nmydmy2     varchar2(1),             /*No Use                                 */
                                     /*編號方式1.流水號 2.年月                */
nmydmy3     varchar2(1),             /*抛转凭证                               */
                                     /*拋轉傳票                               */
nmydmy4     varchar2(1),             /*No Use                                 */
nmyacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
nmyuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nmygrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nmymodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nmydate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nmydmy5     varchar2(1),             /*红冲否(Y/N)                            */
nmyglcr     varchar2(1),             /*是否直接抛转总帐                       */
nmygslp     varchar2(5),             /*总帐单别                               */
nmygslp1    varchar2(5),             /*总帐第二单别                           */
nmydmy6     varchar2(1),             /*是否自动生成对应内部帐户资             */
                                     /*For 內部帳戶                           */
nmyoriu     varchar2(10),            /*资料建立者                             */
nmyorig     varchar2(10),            /*资料建立部门                           */
nmyud01     varchar2(255),           /*自订字段                               */
nmyud02     varchar2(40),            /*自订字段                               */
nmyud03     varchar2(40),            /*自订字段                               */
nmyud04     varchar2(40),            /*自订字段                               */
nmyud05     varchar2(40),            /*自订字段                               */
nmyud06     varchar2(255),           /*自订字段                               */
nmyud07     number(15,3),            /*自订字段                               */
nmyud08     number(15,3),            /*自订字段                               */
nmyud09     number(15,3),            /*自订字段                               */
nmyud10     number(10),              /*自订字段                               */
nmyud11     number(10),              /*自订字段                               */
nmyud12     number(10),              /*自订字段                               */
nmyud13     date,                    /*自订字段                               */
nmyud14     date,                    /*自订字段                               */
nmyud15     date                     /*自订字段                               */
);

alter table nmy_file add  constraint nmy_pk primary key  (nmyslip) enable validate;
grant select on nmy_file to tiptopgp;
grant update on nmy_file to tiptopgp;
grant delete on nmy_file to tiptopgp;
grant insert on nmy_file to tiptopgp;
grant index on nmy_file to public;
grant select on nmy_file to ods;
