/*
================================================================================
檔案代號:apy_file
檔案名稱:AAP-单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table apy_file
(
apyslip     varchar2(5) NOT NULL,    /*单    别                               */
                                     /*單    別                               */
apydesc     varchar2(80),            /*单据名称                               */
                                     /*單據名稱                               */
apyauno     varchar2(1),             /*自动编号否                             */
                                     /*自動編號否                             */
                                     /*正確值 Y/N                             */
                                     /*Y: 是                                  */
                                     /*N: 否                                  */
apymxno     varchar2(20),            /*已用单号                               */
                                     /*已用單號                               */
apykind     varchar2(2),             /*单据性质                               */
                                     /*單據性質                               */
                                     /*11.進貨發票 12.雜項應付 15.預付申請    */
                                     /*21.折讓     22.D.M.     23.預付 24.暫付*/
                                     /*33.付款單   41.成本分攤                */
apyapr      varchar2(1),             /*签核处理                               */
                                     /*簽核處理                               */
                                     /*正確值 Y/N                             */
                                     /*Y: 是                                  */
                                     /*N: 否                                  */
apyatsg     varchar2(1),             /*是否自动赋予签核等级                   */
                                     /*是否自動賦予簽核等級                   */
                                     /*正確值 Y/N                             */
                                     /*Y: 是                                  */
                                     /*N: 否                                  */
apysign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
apydays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
apyprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
apyprint    varchar2(1),             /*立即打印                               */
                                     /*立即列印                               */
                                     /*單據輸入時是否立即列印                 */
apydmy1     varchar2(1),             /*立即审核                               */
                                     /*立即確認                               */
                                     /*單據輸入時是否立即確認                 */
apydmy2     varchar2(1),             /*No Use                                 */
                                     /*編號方式1.流水號 2.依年月              */
apydmy3     varchar2(1),             /*是否抛转凭证                           */
                                     /*是否拋轉傳票                           */
apydmy4     varchar2(5),             /*相对应单别                             */
                                     /*單據性質                               */
                                     /*15(預付申請)相對應單別(暫付)           */
                                     /*17(預付付款)相對應單別(預付)           */
                                     /*33(付款單)  相對應單別(溢付)           */
apydmy5     varchar2(1),             /*是否做预算控管                         */
                                     /*是否做預算控管  (For 請採購預算)       */
apyacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
apyuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
apygrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
apymodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
apydate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
apydmy6     varchar2(1),             /*红冲否(Y/N)                            */
apyglcr     varchar2(1),             /*是否直接抛转总帐                       */
apygslp     varchar2(5),             /*总帐单别                               */
apygslp1    varchar2(5),             /*总帐第二单别                           */
apydmy7     varchar2(1),             /*是否自动生成内部银行帐户资             */
                                     /*For 內部帳戶                           */
apyvcode    varchar2(20),            /*申报税号                               */
apyoriu     varchar2(10),            /*资料建立者                             */
apyorig     varchar2(10)             /*资料建立部门                           */
);

alter table apy_file add  constraint apy_pk primary key  (apyslip) enable validate;
grant select on apy_file to tiptopgp;
grant update on apy_file to tiptopgp;
grant delete on apy_file to tiptopgp;
grant insert on apy_file to tiptopgp;
grant index on apy_file to public;
grant select on apy_file to ods;
