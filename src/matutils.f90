module matutils
    implicit none
    private

    !declaration
    public :: MatrixSparse, trace, norme, mat_vect
    
    type MatrixSparse
        double precision, dimension(:), allocatable :: val
        integer, dimension(:), allocatable :: nnz
        integer, dimension(:), allocatable :: icol
    end type MatrixSparse

    
    interface operator(*)
        module procedure mat_vect, mat_mat
    end interface


    contains
        subroutine trace(A)
            !declarations
            type(MatrixSparse), intent(in) :: A 
            double precision :: trax
            integer :: i, k, n
            

            !Instructions
            n = size(A%nnz) - 1
            trax = 0
            do i = 1, n
                do k = A%nnz(i) + 1, A%nnz(i+1) 
                    if (A%icol(k) == i) then
                        trax = trax + A%val(k)
                    end if 
                end do
            end do
            print*, 'Trace of A is : ', trax
        end subroutine trace

        subroutine norme(A)
            !declarations
            type(MatrixSparse), intent(in) :: A 
            double precision, dimension(size(A%nnz) - 1) :: z
            double precision :: norm
            integer :: i, j, n
            
            !Instructions
            norm = 0
            n = size(A%nnz) - 1
            z = 0
            do i = 1, n
                do j = A%nnz(i) + 1, A%nnz(i+1)
                    z(i) = z(i) + abs(A%val(j))
                end do
            end do 
            norm = maxval(z)
            print*, 'Norm of A is : ', norm
        end subroutine norme

        function mat_vect(A,x) result(y)
            !product matrix vector
            !declarations
            type(MatrixSparse), intent(in) :: A
            double precision, dimension(:), intent(in) :: x
            double precision, dimension(size(A%nnz) - 1) :: y
            integer :: i, k, n

            !Instructions
            n = size(A%nnz) - 1 !number of rows in the matrix
            if (size(x) .NE. n) then
                print*, 'Not conforming dimension'
            end if

            
            do i=1,n 
                y(i) = 0
                ! Iterate only over non-zero elements for row i
                do k=A%nnz(i) + 1, A%nnz(i+1)
                    y(i) = y(i) + A%val(k)*x(A%icol(k))
                end do 
            end do 

        end function mat_vect

        function mat_mat(A,B) result(C)
            !product matrix matrix
            !declarations
            type(MatrixSparse), intent(in) :: A
            double precision, dimension(:,:), intent(in) :: B
            double precision, dimension(size(A%nnz) - 1, size(B, dim=2)) :: C
            double precision :: s 
            integer :: i, j, k, l, n, m


            !Instructions
            n = size(A%nnz) - 1  !ligne number of A
            m = size(B, dim=2)   !column number of B
            if (n .NE. m) then
                print*, 'Not matching dimension'
            end if

            s = 0
            do j = 1, m 
                do i = 1, n 
                    do k=A%nnz(i) + 1, A%nnz(i+1)
                        l = A%icol(k)
                        s = s + A%val(k) * B(l, j)
                    end do
                    C(i,j) = s 
                end do 
            end do

        end function mat_mat


end module matutils