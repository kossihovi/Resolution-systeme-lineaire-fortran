module linearsolver
    use matutils
    implicit none

    contains
        subroutine jacobi(A,b,kmax,epsilon)
            !implicit none
            !declarations
            type(MatrixSparse), intent(in) :: A
            double precision, dimension(size(A%nnz)-1), intent(in) :: b !second member
            double precision, dimension(size(b)) ::  x !solution vector
            double precision, dimension(size(b)) :: D, y ! Diagonal vector and y vector
            integer, intent(in) :: kmax
            double precision, intent(in) :: epsilon 
            double precision :: r
            integer :: i, j, n, k
            logical :: converge = .FALSE.

            !Instructions
            n = size(A%nnz) - 1
            if (n .NE. size(b)) then
                    print*, 'Not matching dimension'
                    stop
            end if

            ! diagonale de A
            D = 0
            do i = 1, n
                do j = A%nnz(i) + 1, A%nnz(i+1)
                    if (A%icol(j) == i) D(i) = A%val(j)
                end do
            end do
            print*, 'The diagonal of matrix A is : ', D 

            if (any(D .EQ. 0)) then  !verify if at least one elemnnt is null
                print*, 'zero on the diagonal'
                return
            end if

            !print *, 'b       = ', b
            !print *, 'kmax    = ', kmax
            !print *, 'epsilon = ', epsilon
            
            k = 0
            x = 0
            !converge = .FALSE.
            do while(k .LT. kmax)
                !calcul of y=Ax
                y = A * x !or y=mat_vect(A,x) 
                !compute of residue of L2 error
                r = sqrt(dot_product(b-y, b-y))
                if (r .LT. epsilon) then
                    converge = .TRUE.
                    exit
                else 
                    x = x - y/D + b/D
                    k = k + 1 
                end if 
            end do 

            if (.NOT. converge) then 
                print*, 'The algorithm attains kmax'
            end if 
            print*, 'Iterations : ', k
            print*, 'The solution of the linear system is :', x
            print*, 'The final residu is', r

            !Write the solution in file 'res.dat'
            open(unit=1, file= 'res.dat', status='replace')
            write(1, *) x
            close(1)

        end subroutine jacobi


end module linearsolver